-- Drill 05. `:vimgrep` searches files and fills the quickfix list. Return how many
-- entries the search produces across the fixture files.
--
-- Note the `j` flag in the command: without it :vimgrep jumps to the first match.
return {
  goal = 'Return the number of quickfix entries the search produces',
  check = function()
    local dir = vim.fn.tempname()
    vim.fn.mkdir(dir .. '/sub', 'p')
    vim.fn.writefile({ 'alpha NEEDLE one', 'beta two', 'gamma NEEDLE three' }, dir .. '/a.txt')
    vim.fn.writefile({ 'delta four', 'epsilon NEEDLE five' }, dir .. '/b.txt')
    vim.fn.writefile({ 'zeta NEEDLE six' }, dir .. '/sub/c.txt')
    vim.cmd('silent! only')
    vim.cmd('cd ' .. vim.fn.fnameescape(dir))
    vim.fn.setqflist({})
    vim.cmd('silent vimgrep /NEEDLE/j **/*.txt')

    -- ANSWER_BEGIN
    local answer = #vim.fn.getqflist()
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(
      answer == 4,
      ('the list holds %d entries; you said %s'):format(#vim.fn.getqflist(), tostring(answer))
    )
  end,
}
