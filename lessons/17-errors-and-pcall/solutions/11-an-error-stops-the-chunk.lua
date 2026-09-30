-- Drill 11. The reason lesson 00 put a marker on the last line. An error stops the CHUNK,
-- not Neovim: everything above it took effect and everything below it did not.
--
-- Return a list: { did_the_first_line_run, did_the_last_line_run }.
return {
  goal = 'Return which lines of a half-failing chunk took effect',
  check = function()
    _G.hero_probe_first, _G.hero_probe_last = nil, nil
    local dir = vim.fn.tempname()
    vim.fn.mkdir(dir, 'p')
    vim.fn.writefile({
      '_G.hero_probe_first = true',
      "error('stop here')",
      '_G.hero_probe_last = true',
    }, dir .. '/half.lua')
    pcall(vim.cmd, 'source ' .. dir .. '/half.lua')

    -- ANSWER_BEGIN
    local answer = { _G.hero_probe_first == true, _G.hero_probe_last == true }
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer[1] == true, 'the line above the error ran')
    assert(answer[2] == false, 'the line below it did not')
    _G.hero_probe_first, _G.hero_probe_last = nil, nil
  end,
}
