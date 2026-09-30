-- Drill 13. A window created by splitting INHERITS a copy of the location list of the
-- window it came from. Return the new window's location-list count.
return {
  goal = "Return the new window's location-list count after a split",
  check = function()
    local dir = vim.fn.tempname()
    vim.fn.mkdir(dir, 'p')
    vim.fn.writefile({ 'alpha NEEDLE one', 'beta', 'gamma NEEDLE three' }, dir .. '/a.txt')
    vim.cmd('silent! only')
    vim.o.hidden = true
    vim.cmd('cd ' .. vim.fn.fnameescape(dir))
    vim.fn.setloclist(0, {})
    vim.cmd('silent lvimgrep /NEEDLE/j a.txt')
    vim.cmd('split')

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(
      answer == 2,
      ('expected the list to be inherited (2 entries), got %s'):format(tostring(answer))
    )
    vim.cmd('silent! only')
  end,
}
