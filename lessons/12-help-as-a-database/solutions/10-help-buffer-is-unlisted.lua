-- Drill 10. Connecting to lesson 10's buffer model: the help buffer is unlisted, which
-- is why `:ls` hides it and `:ls!` shows it. It is also unmodifiable.
--
-- Return { buftype, buflisted, modifiable } for an open help buffer.
return {
  goal = "Return the help buffer's buftype, buflisted and modifiable values",
  check = function()
    vim.cmd('silent! only')
    vim.cmd('help vim.keymap.set()')

    -- ANSWER_BEGIN
    local answer = { vim.bo.buftype, vim.bo.buflisted, vim.bo.modifiable }
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer[1] == 'help', ('buftype is %q'):format(tostring(answer[1])))
    assert(answer[2] == false, 'the help buffer is UNLISTED, so :ls does not show it')
    assert(answer[3] == false, 'the help buffer is not modifiable')
    pcall(vim.cmd, 'helpclose')
  end,
}
