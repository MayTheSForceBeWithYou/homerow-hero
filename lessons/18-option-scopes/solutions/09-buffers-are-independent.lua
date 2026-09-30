-- Drill 09. Set a buffer-scoped option differently in two buffers and return true if they
-- disagree.
return {
  goal = 'Return whether two buffers can hold different values of a buffer-scoped option',
  check = function()
    local b1 = vim.api.nvim_create_buf(true, true)
    local b2 = vim.api.nvim_create_buf(true, true)

    -- ANSWER_BEGIN
    vim.bo[b1].expandtab = true
    vim.bo[b2].expandtab = false
    local answer = vim.bo[b1].expandtab ~= vim.bo[b2].expandtab
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == true, 'buffer-scoped options are per buffer')
  end,
}
