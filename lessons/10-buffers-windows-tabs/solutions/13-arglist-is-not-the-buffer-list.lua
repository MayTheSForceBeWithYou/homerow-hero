-- Drill 13. The argument list is a set you DECLARE; the buffer list is everything
-- loaded. Set the arglist to two files while more buffers are loaded, then return
-- { argc, listed_buffer_count } and let the check confirm they differ.
return {
  goal = 'Return the argument count and the listed-buffer count, in that order',
  hint = 'vim.fn.argc() and vim.fn.getbufinfo({ buflisted = 1 }).',
  check = function()
    vim.cmd('silent! only')
    for _, n in ipairs({ 'zz_a.txt', 'zz_b.txt', 'zz_c.txt', 'zz_d.txt' }) do
      vim.cmd('edit ' .. n)
    end
    vim.cmd('args zz_a.txt zz_c.txt')

    -- TODO_GUARD

    local answer = { vim.fn.argc(), #vim.fn.getbufinfo({ buflisted = 1 }) } -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer[1] == 2, ('argc should be 2, got %s'):format(tostring(answer[1])))
    assert(
      answer[2] > answer[1],
      'more buffers should be loaded than are in the arglist -- they are different collections'
    )
  end,
}
