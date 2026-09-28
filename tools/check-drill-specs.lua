-- tools/check-drill-specs.lua -- exercises and solutions must pose the same problem.
--
-- Run via tools/check-drill-specs.sh.
--
-- The real drift risk in a paired exercises/ + solutions/ tree is not prose -- an
-- exercise should teach more than its solution -- but the *specification*: if a
-- solution's `want` is edited and its exercise's is not, the learner is handed an
-- unsolvable drill and the reference answer still passes CI.
--
-- So this compares every field that defines the problem, and ignores the answer
-- (`keys`, `run`, `check`) and all commentary.

local SPEC_FIELDS = {
  'goal',
  'start',
  'cursor',
  'want',
  'want_cursor',
  'want_registers',
  'want_mode',
  'filetype',
  'value',
}

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

local function load_drill(path)
  local chunk, err = loadfile(path)
  if not chunk then
    return nil, tostring(err)
  end
  local ok, drill = pcall(chunk)
  if not ok then
    return nil, tostring(drill)
  end
  return drill, nil
end

local problems = {}
local checked = 0

for _, lesson in ipairs(vim.fn.glob('lessons/*', false, true)) do
  local ex_dir, sol_dir = lesson .. '/exercises', lesson .. '/solutions'
  if vim.fn.isdirectory(ex_dir) == 1 and vim.fn.isdirectory(sol_dir) == 1 then
    local exercises = vim.fn.glob(ex_dir .. '/*.lua', false, true)
    local solutions = vim.fn.glob(sol_dir .. '/*.lua', false, true)

    -- Filenames must mirror exactly, in both directions.
    local have = {}
    for _, p in ipairs(solutions) do
      have[vim.fn.fnamemodify(p, ':t')] = true
    end
    for _, p in ipairs(exercises) do
      local name = vim.fn.fnamemodify(p, ':t')
      if not have[name] then
        table.insert(problems, ('%s has no matching solution'):format(p))
      end
      have[name] = nil
    end
    for name in pairs(have) do
      table.insert(problems, ('%s/%s has no matching exercise'):format(sol_dir, name))
    end

    for _, ex_path in ipairs(exercises) do
      local name = vim.fn.fnamemodify(ex_path, ':t')
      local sol_path = sol_dir .. '/' .. name
      if vim.fn.filereadable(sol_path) == 1 then
        local ex, ex_err = load_drill(ex_path)
        local sol, sol_err = load_drill(sol_path)
        if not ex then
          table.insert(problems, ('%s will not load: %s'):format(ex_path, ex_err))
        elseif not sol then
          table.insert(problems, ('%s will not load: %s'):format(sol_path, sol_err))
        else
          checked = checked + 1
          for _, field in ipairs(SPEC_FIELDS) do
            if not deep_equal(ex[field], sol[field]) then
              table.insert(
                problems,
                ('%s: field `%s` differs between exercise and solution\n    exercise: %s\n    solution: %s'):format(
                  name,
                  field,
                  vim.inspect(ex[field]):gsub('%s+', ' '),
                  vim.inspect(sol[field]):gsub('%s+', ' ')
                )
              )
            end
          end
          -- The exercise must not simply be the solution.
          if ex.keys ~= nil and ex.keys == sol.keys and sol.keys ~= '' then
            table.insert(problems, ("%s: exercise ships the solution's keys"):format(name))
          end
        end
      end
    end
  end
end

if #problems > 0 then
  io.stdout:write('drill spec mismatches:\n')
  for _, p in ipairs(problems) do
    io.stdout:write('  ' .. p .. '\n')
  end
  os.exit(1)
end

io.stdout:write(('check-drill-specs: %d drill pairs agree on the problem posed.\n'):format(checked))
os.exit(0)
