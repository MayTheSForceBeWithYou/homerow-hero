-- Drill 10. The same for a window-scoped option, using the window table.
return {
  goal = 'Return whether two windows can hold different values of a window-scoped option',
  hint = 'The window equivalent of vim.bo.',
  check = function()
    vim.cmd('silent! only')
    vim.cmd('split')
    local wins = vim.api.nvim_list_wins()

    -- ANSWER_BEGIN
    vim.wo[wins[1]].number = true
    vim.wo[wins[2]].number = false
    local answer = vim.wo[wins[1]].number ~= vim.wo[wins[2]].number
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == true, 'window-scoped options are per window')
    vim.cmd('silent! only')
  end,
}
