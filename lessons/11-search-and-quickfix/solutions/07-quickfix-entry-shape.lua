-- Drill 07. A quickfix entry is a POSITION WITH A MESSAGE. Return the first entry's
-- line and column as a list: { lnum, col }.
return {
  goal = 'Return the line and column of the first quickfix entry',
  hint = 'getqflist() returns a list of tables; look at the field names.',
  check = function()
    local dir = vim.fn.tempname()
    vim.fn.mkdir(dir, 'p')
    vim.fn.writefile({ 'alpha NEEDLE one' }, dir .. '/a.txt')
    vim.cmd('silent! only')
    vim.cmd('cd ' .. vim.fn.fnameescape(dir))
    vim.fn.setqflist({})
    vim.cmd('silent vimgrep /NEEDLE/j a.txt')

    -- ANSWER_BEGIN
    local e = vim.fn.getqflist()[1]
    local answer = { e.lnum, e.col }
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    local first = vim.fn.getqflist()[1]
    assert(
      answer[1] == first.lnum,
      ('lnum is %d, you said %s'):format(first.lnum, tostring(answer[1]))
    )
    assert(
      answer[2] == first.col,
      ('col is %d, you said %s'):format(first.col, tostring(answer[2]))
    )
    assert(answer[1] == 1 and answer[2] == 7, 'expected line 1, column 7')
  end,
}
