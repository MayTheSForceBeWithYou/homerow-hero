-- Drill 09. Running off the end of the quickfix list is an error, and it is how you
-- know you are finished rather than stuck. Return its number, as a string like 'E999'.
return {
  goal = 'Return the error number for running past the end of the quickfix list',
  hint = 'The check reproduces it, so run the drill to read the real message.',
  check = function()
    local dir = vim.fn.tempname()
    vim.fn.mkdir(dir, 'p')
    vim.fn.writefile({ 'only NEEDLE here' }, dir .. '/a.txt')
    vim.cmd('silent! only')
    vim.cmd('cd ' .. vim.fn.fnameescape(dir))
    vim.fn.setqflist({})
    vim.cmd('silent vimgrep /NEEDLE/j a.txt')
    vim.cmd('silent clast')

    local answer = nil -- <- your answer
    assert(answer ~= nil, 'DRILL_TODO')

    local ok, err = pcall(vim.cmd, 'cnext')
    assert(not ok, 'stepping past the last entry should fail')
    assert(
      tostring(err):find(answer, 1, true) ~= nil,
      ('the real error was %q, which does not contain %q'):format(tostring(err), answer)
    )
  end,
}
