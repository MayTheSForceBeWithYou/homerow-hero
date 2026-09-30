-- Drill 09. Set a buffer-scoped option differently in two buffers and return true if they
-- disagree.
return {
  goal = 'Return whether two buffers can hold different values of a buffer-scoped option',
  check = function()
    local b1 = vim.api.nvim_create_buf(true, true)
    local b2 = vim.api.nvim_create_buf(true, true)

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == true, 'buffer-scoped options are per buffer')
  end,
}
