-- Drill 04. Without an index these tables mean CURRENT. Set a buffer variable with no
-- index, then read it back through the explicit index for the same buffer.
return {
  goal = 'Set a buffer variable without an index and read it via the explicit index',
  check = function()
    local b = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_set_current_buf(b)

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == 'current', 'the unindexed form writes the current buffer')
  end,
}
