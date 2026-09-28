-- tools/drill.lua -- the drill runner for homerow-hero.
--
-- Run through the `./drill` wrapper, not directly. The wrapper exists because
-- Neovim writes editor messages ("recording @q", a typed `:%s/...`, undo
-- reports) to *stderr* while this script writes its report to *stdout*. The
-- wrapper hides stderr unless something actually fails.
--
--   nvim --headless -u NONE -l tools/drill.lua <path>...
--
-- A drill is a Lua file returning one table. Three kinds, told apart by which
-- key is present:
--
--   keys   -> KEYS drill.  Load `start` into a scratch buffer, place the
--             cursor, feed `keys`, compare the buffer against `want`.
--   value  -> VALUE drill. Call `run()`, deep-compare its result to `value`.
--   check  -> CHECK drill. Call `check()`; any error is a failure.
--
-- Full key reference lives in AUTHORING.md under "Drill contract".

local uv = vim.uv or vim.loop

-- Neovim defaults that would otherwise corrupt a drill: swap files in the
-- scratch dir, "-- INSERT --" noise, a `more` prompt that would hang headless.
vim.o.showmode = false
vim.o.more = false
vim.o.report = 9999
vim.o.swapfile = false
vim.o.undofile = false
vim.o.shada = ''

local GREEN, RED, YELLOW, DIM, BOLD, RESET =
  '\27[32m', '\27[31m', '\27[33m', '\27[2m', '\27[1m', '\27[0m'
if os.getenv('NO_COLOR') or os.getenv('TERM') == 'dumb' then
  GREEN, RED, YELLOW, DIM, BOLD, RESET = '', '', '', '', '', ''
end

local function say(fmt, ...)
  io.stdout:write((select('#', ...) > 0 and fmt:format(...) or fmt) .. '\n')
end

---------------------------------------------------------------------------
-- comparison helpers
---------------------------------------------------------------------------

local function deep_equal(a, b)
  if a == b then
    return true
  end
  if type(a) ~= 'table' or type(b) ~= 'table' then
    return false
  end
  for k, v in pairs(a) do
    if not deep_equal(v, b[k]) then
      return false
    end
  end
  for k in pairs(b) do
    if a[k] == nil then
      return false
    end
  end
  return true
end

-- Render a value for the got/want report. Buffer contents (a list of lines)
-- read far better one-per-line than as an inspect blob.
local function render(value)
  if type(value) == 'table' and (#value > 0 or next(value) == nil) then
    local all_strings = true
    for _, v in ipairs(value) do
      if type(v) ~= 'string' then
        all_strings = false
        break
      end
    end
    if all_strings and #value > 0 then
      local parts = {}
      for i, line in ipairs(value) do
        parts[i] = ('%s%2d|%s%s'):format(DIM, i, RESET, line)
      end
      return '\n' .. table.concat(parts, '\n')
    end
  end
  return vim.inspect(value)
end

---------------------------------------------------------------------------
-- drill kinds
---------------------------------------------------------------------------

local function fresh_buffer(lines, cursor, filetype)
  local buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_set_current_buf(buf)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines or { '' })
  if filetype then
    vim.bo[buf].filetype = filetype
  end
  local ok = pcall(vim.api.nvim_win_set_cursor, 0, cursor or { 1, 0 })
  if not ok then
    return buf, ('cursor %s is outside the start buffer'):format(vim.inspect(cursor))
  end
  return buf, nil
end

-- 'mtx' is deliberate and load-bearing:
--   m  apply mappings, so a drill that sets a keymap can exercise it
--   t  treat as typed, so `.`, undo blocks and macro recording behave
--   x  execute now, so the buffer is settled when we read it back
-- 'nx' (no-remap) looks tidier but silently breaks macro replay: `2@q`
-- becomes a no-op and the drill passes a wrong answer.
local function feed(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'mtx', false)
end

local function run_keys_drill(drill)
  if drill.keys == '' then
    return 'todo'
  end

  local buf, cursor_err = fresh_buffer(drill.start, drill.cursor, drill.filetype)
  if cursor_err then
    return 'fail', cursor_err
  end

  if drill.setup then
    local ok, err = pcall(drill.setup)
    if not ok then
      return 'fail', 'setup() raised: ' .. tostring(err)
    end
  end

  local ok, err = pcall(feed, drill.keys)
  if not ok then
    return 'fail', 'typing those keys raised: ' .. tostring(err)
  end

  -- Escape whatever mode the keys left us in, so the next drill starts clean
  -- and a half-finished insert does not swallow the following drill's keys.
  if vim.api.nvim_get_mode().mode ~= 'n' then
    pcall(feed, '<Esc><Esc>')
  end

  local got = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  if not deep_equal(got, drill.want) then
    return 'fail', nil, got, drill.want, 'buffer'
  end

  if drill.want_cursor then
    local got_cursor = vim.api.nvim_win_get_cursor(0)
    if not deep_equal(got_cursor, drill.want_cursor) then
      return 'fail', nil, got_cursor, drill.want_cursor, 'cursor {line, col} (col is 0-based)'
    end
  end

  if drill.want_registers then
    for name, expected in pairs(drill.want_registers) do
      local got_reg = vim.fn.getreg(name)
      if got_reg ~= expected then
        return 'fail', nil, got_reg, expected, ('register "%s'):format(name)
      end
    end
  end

  if drill.want_mode then
    local got_mode = vim.api.nvim_get_mode().mode
    if got_mode ~= drill.want_mode then
      return 'fail', nil, got_mode, drill.want_mode, 'mode'
    end
  end

  return 'pass'
end

local function run_value_drill(drill)
  local ok, got = pcall(drill.run)
  if not ok then
    return 'fail', 'run() raised: ' .. tostring(got)
  end
  if got == nil and drill.value ~= nil then
    return 'todo'
  end
  if not deep_equal(got, drill.value) then
    return 'fail', nil, got, drill.value, 'return value of run()'
  end
  return 'pass'
end

local function run_check_drill(drill)
  local ok, err = pcall(drill.check)
  if not ok then
    local msg = tostring(err)
    if msg:match('DRILL_TODO') then
      return 'todo'
    end
    return 'fail', msg
  end
  return 'pass'
end

---------------------------------------------------------------------------
-- loading
---------------------------------------------------------------------------

local REQUIRED = { 'goal' }

local function validate(drill)
  if type(drill) ~= 'table' then
    return ('must return a table, got %s'):format(type(drill))
  end
  for _, key in ipairs(REQUIRED) do
    if type(drill[key]) ~= 'string' then
      return ('missing required string field `%s`'):format(key)
    end
  end
  local kinds = 0
  for _, key in ipairs({ 'keys', 'run', 'check' }) do
    if drill[key] ~= nil then
      kinds = kinds + 1
    end
  end
  if kinds == 0 then
    return 'needs one of `keys`, `run` or `check`'
  end
  if kinds > 1 then
    return 'has more than one of `keys`, `run`, `check` -- pick one kind'
  end
  if drill.keys ~= nil then
    if type(drill.want) ~= 'table' then
      return 'a `keys` drill needs `want` (a list of expected buffer lines)'
    end
    if type(drill.start) ~= 'table' then
      return 'a `keys` drill needs `start` (a list of starting buffer lines)'
    end
  end
  return nil
end

local function load_drill(path)
  local chunk, load_err = loadfile(path)
  if not chunk then
    return nil, 'will not load: ' .. tostring(load_err)
  end
  local ok, drill = pcall(chunk)
  if not ok then
    return nil, 'raised while loading: ' .. tostring(drill)
  end
  local invalid = validate(drill)
  if invalid then
    return nil, invalid
  end
  return drill, nil
end

local function expand_targets(args)
  local files = {}
  local function add_dir(dir)
    local found = vim.fn.glob(dir .. '/*.lua', false, true)
    table.sort(found)
    vim.list_extend(files, found)
  end
  for _, arg in ipairs(args) do
    local stat = uv.fs_stat(arg)
    if stat and stat.type == 'directory' then
      add_dir(arg)
    elseif stat then
      table.insert(files, arg)
    else
      say('%sno such drill path: %s%s', RED, arg, RESET)
      os.exit(2)
    end
  end
  return files
end

---------------------------------------------------------------------------
-- main
---------------------------------------------------------------------------

local args = _G.arg or {}
if #args == 0 then
  say('usage: nvim --headless -u NONE -l tools/drill.lua <file-or-dir>...')
  say('  (you almost certainly want ./drill instead)')
  os.exit(2)
end

local files = expand_targets(args)
if #files == 0 then
  say('%sno .lua drills found in: %s%s', YELLOW, table.concat(args, ' '), RESET)
  os.exit(2)
end

local counts = { pass = 0, fail = 0, todo = 0, broken = 0 }
local failures = {}

for _, path in ipairs(files) do
  local name = vim.fn.fnamemodify(path, ':t:r')
  local drill, load_err = load_drill(path)

  if not drill then
    counts.broken = counts.broken + 1
    say('%s BROKEN %s %s', RED .. BOLD, RESET, name)
    say('        %s%s%s', DIM, load_err, RESET)
    table.insert(failures, path)
  else
    local status, message, got, want, what = (function()
      if drill.keys ~= nil then
        return run_keys_drill(drill)
      elseif drill.run ~= nil then
        return run_value_drill(drill)
      else
        return run_check_drill(drill)
      end
    end)()

    counts[status] = counts[status] + 1

    if status == 'pass' then
      say('%s  PASS  %s %s %s-- %s%s', GREEN, RESET, name, DIM, drill.goal, RESET)
    elseif status == 'todo' then
      say('%s  TODO  %s %s %s-- %s%s', YELLOW, RESET, name, DIM, drill.goal, RESET)
    else
      table.insert(failures, path)
      say('%s  FAIL  %s %s', RED .. BOLD, RESET, name)
      say('        %sgoal: %s%s', DIM, drill.goal, RESET)
      if message then
        say('        %s', message)
      end
      if what then
        say('        %s differs:', what)
        say('          got:  %s', render(got))
        say('          want: %s', render(want))
      end
      if drill.hint then
        say('        %shint: %s%s', DIM, drill.hint, RESET)
      end
    end
  end
end

say('')
local total = #files
local summary = ('%d drill%s: %s%d pass%s'):format(
  total,
  total == 1 and '' or 's',
  GREEN,
  counts.pass,
  RESET
)
if counts.todo > 0 then
  summary = summary .. (', %s%d todo%s'):format(YELLOW, counts.todo, RESET)
end
if counts.fail > 0 then
  summary = summary .. (', %s%d fail%s'):format(RED, counts.fail, RESET)
end
if counts.broken > 0 then
  summary = summary .. (', %s%d broken%s'):format(RED, counts.broken, RESET)
end
say('%s', summary)

if counts.fail + counts.broken > 0 then
  say('')
  say('%sre-run just what failed:%s', DIM, RESET)
  say('  ./drill %s', table.concat(failures, ' '))
  os.exit(1)
end
os.exit(0)
