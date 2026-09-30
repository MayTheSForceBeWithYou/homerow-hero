-- Drill 04. The row people get wrong. `vim.o` behaves like `:set`: it writes the local
-- value AND the global default.
--
-- Return a list: { local_after, global_after } having written with vim.o.
return {
  goal = 'Return the local and global values after writing a buffer-scoped option with vim.o',
  hint = 'Predict this before you run it.',
  check = function()
    local b = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_set_current_buf(b)
    vim.api.nvim_set_option_value('shiftwidth', 8, { scope = 'global' })
    vim.api.nvim_set_option_value('shiftwidth', 8, { buf = b })

    vim.o.shiftwidth = 2

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer[1] == 2, ('the local should be 2, got %s'):format(tostring(answer[1])))
    assert(
      answer[2] == 2,
      ('vim.o writes the GLOBAL too, so 2 -- got %s'):format(tostring(answer[2]))
    )
  end,
}
