-- Drill 08. Step through the list. After :cfirst and two :cnext calls, return the
-- basename of the file you are in.
return {
  goal = 'Return the file you land in after :cfirst and two :cnext',
  check = function()
    local dir = vim.fn.tempname()
    vim.fn.mkdir(dir, 'p')
    vim.fn.writefile({ 'alpha NEEDLE one', 'beta', 'gamma NEEDLE three' }, dir .. '/a.txt')
    vim.fn.writefile({ 'delta', 'epsilon NEEDLE five' }, dir .. '/b.txt')
    vim.cmd('silent! only')
    vim.o.hidden = true
    vim.cmd('cd ' .. vim.fn.fnameescape(dir))
    vim.fn.setqflist({})
    vim.cmd('silent vimgrep /NEEDLE/j *.txt')
    vim.cmd('silent cfirst')
    vim.cmd('silent cnext')
    vim.cmd('silent cnext')

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(
      answer == 'b.txt',
      ('expected b.txt -- the third entry -- got %q'):format(tostring(answer))
    )
  end,
}
