-- Drill 03. Set a buffer variable on two different buffers and return true if they are
-- independent.
return {
  goal = 'Return whether two buffers hold independent buffer variables',
  hint = 'The table takes an optional buffer index.',
  check = function()
    local b1 = vim.api.nvim_create_buf(true, true)
    local b2 = vim.api.nvim_create_buf(true, true)

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == true, 'buffer variables are per buffer')
  end,
}
