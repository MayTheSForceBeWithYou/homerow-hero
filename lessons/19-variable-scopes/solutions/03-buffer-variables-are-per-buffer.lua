-- Drill 03. Set a buffer variable on two different buffers and return true if they are
-- independent.
return {
  goal = 'Return whether two buffers hold independent buffer variables',
  hint = 'The table takes an optional buffer index.',
  check = function()
    local b1 = vim.api.nvim_create_buf(true, true)
    local b2 = vim.api.nvim_create_buf(true, true)

    -- ANSWER_BEGIN
    vim.b[b1].note = 'one'
    vim.b[b2].note = 'two'
    local answer = vim.b[b1].note ~= vim.b[b2].note
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == true, 'buffer variables are per buffer')
  end,
}
