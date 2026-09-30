-- Drill 16. For a global-local option, a window with no local value falls back to the
-- global one. Return the statusline each of two windows reports when only one has a local.
return {
  goal = 'Return the statusline of a window with a local value and one without',
  check = function()
    vim.cmd('silent! only')
    vim.api.nvim_set_option_value('statusline', 'GLOBAL', { scope = 'global' })
    vim.cmd('split')
    local wins = vim.api.nvim_list_wins()
    vim.api.nvim_set_option_value('statusline', 'WINLOCAL', { win = wins[1] })

    -- ANSWER_BEGIN
    local answer = {
      vim.api.nvim_get_option_value('statusline', { win = wins[1] }),
      vim.api.nvim_get_option_value('statusline', { win = wins[2] }),
    }
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer[1] == 'WINLOCAL', 'the window with a local uses it')
    assert(answer[2] == 'GLOBAL', 'the window without one falls back to the global')
    vim.cmd('silent! only')
  end,
}
