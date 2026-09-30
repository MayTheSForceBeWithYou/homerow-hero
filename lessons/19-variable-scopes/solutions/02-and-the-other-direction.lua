-- Drill 02. And back. Set it from Vimscript, read it from Lua.
return {
  goal = 'Set a global from Vimscript and read it through vim.g',
  check = function()
    vim.cmd('let g:hero_d02 = "from vimscript"')

    -- ANSWER_BEGIN
    local answer = vim.g.hero_d02
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == 'from vimscript', ('Lua saw %q'):format(tostring(answer)))
    vim.g.hero_d02 = nil
  end,
}
