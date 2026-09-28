-- Drill 17. Set mark `a` in two different buffers at different lines, then return
-- true if the two marks are independent of each other.
return {
  goal = 'Return whether mark a in one buffer is independent of mark a in another',
  run = function()
    local function scratch(lines)
      local b = vim.api.nvim_create_buf(true, true)
      vim.api.nvim_set_current_buf(b)
      vim.api.nvim_buf_set_lines(b, 0, -1, false, lines)
      return b
    end

    local first = scratch({ 'a', 'b', 'c', 'd' })
    vim.api.nvim_win_set_cursor(0, { 2, 0 })
    vim.api.nvim_feedkeys('ma', 'mtx', false)

    local second = scratch({ 'a', 'b', 'c', 'd' })
    vim.api.nvim_win_set_cursor(0, { 4, 0 })
    vim.api.nvim_feedkeys('ma', 'mtx', false)

    local m1 = vim.api.nvim_buf_get_mark(first, 'a')
    local m2 = vim.api.nvim_buf_get_mark(second, 'a')
    return m1[1] ~= m2[1] -- <- your answer
  end,
  value = true,
}
