-- Drill 17. The consequence people trip on: assigning '' to a global-local STRING option
-- does not mean "empty" -- it means "use the global".
--
-- Return what the window reports after its local is cleared.
return {
  goal = 'Return the statusline a window reports after clearing its local value',
  check = function()
    vim.cmd('silent! only')
    vim.api.nvim_set_option_value('statusline', 'GLOBAL', { scope = 'global' })
    local w = vim.api.nvim_get_current_win()
    vim.api.nvim_set_option_value('statusline', 'WINLOCAL', { win = w })
    vim.api.nvim_set_option_value('statusline', '', { win = w })

    -- ANSWER_BEGIN
    local answer = vim.api.nvim_get_option_value('statusline', { win = w })
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(
      answer == 'GLOBAL',
      ('an empty local restores the global fallback, so "GLOBAL"; got %q'):format(tostring(answer))
    )
  end,
}
