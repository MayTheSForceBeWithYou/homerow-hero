-- Drill 10. The quickfix window is an ordinary window showing an ordinary buffer, which
-- is why window commands work on it and why you can give it its own mappings.
--
-- Return its 'buftype' and 'filetype' as a list, in that order.
return {
  goal = "Return the quickfix window's buftype and filetype",
  check = function()
    local dir = vim.fn.tempname()
    vim.fn.mkdir(dir, 'p')
    vim.fn.writefile({ 'alpha NEEDLE one' }, dir .. '/a.txt')
    vim.cmd('silent! only')
    vim.cmd('cd ' .. vim.fn.fnameescape(dir))
    vim.fn.setqflist({})
    vim.cmd('silent vimgrep /NEEDLE/j a.txt')
    vim.cmd('copen')

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer[1] == 'quickfix', ('buftype is %q'):format(tostring(answer[1])))
    assert(answer[2] == 'qf', ('filetype is %q'):format(tostring(answer[2])))
    vim.cmd('cclose')
  end,
}
