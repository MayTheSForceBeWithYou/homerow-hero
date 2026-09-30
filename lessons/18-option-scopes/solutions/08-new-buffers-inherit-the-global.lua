-- Drill 08. Why the vim.o row matters. A NEW buffer inherits the global default, so a
-- buffer-scoped option written with vim.o leaks into every file you open afterwards.
--
-- Return the shiftwidth a freshly created buffer comes up with.
return {
  goal = 'Return the shiftwidth a new buffer inherits after vim.o set it to 3',
  hint = 'Which scope does a new buffer copy from?',
  check = function()
    local first = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_set_current_buf(first)
    vim.api.nvim_set_option_value('shiftwidth', 8, { scope = 'global' })
    vim.o.shiftwidth = 3

    local fresh = vim.api.nvim_create_buf(true, true)

    -- ANSWER_BEGIN
    local answer = vim.bo[fresh].shiftwidth
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(
      answer == 3,
      ('a new buffer inherits the global, which vim.o set to 3; got %s'):format(tostring(answer))
    )
  end,
}
