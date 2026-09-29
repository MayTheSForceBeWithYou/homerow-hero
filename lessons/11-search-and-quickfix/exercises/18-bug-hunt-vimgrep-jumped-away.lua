-- Drill 18. BUG HUNT -- starts FAILING.
--
-- The intent is to fill the quickfix list and STAY where you are, so you can read the
-- list before acting. Run it: the search threw you into the first matching file, so
-- the assertion about still being in the starting buffer fails.
--
-- One flag on :vimgrep is the difference. The list itself is correct either way.
return {
  goal = 'Fill the quickfix list without being jumped to the first match',
  hint = 'A single letter, after the closing slash of the pattern.',
  check = function()
    local dir = vim.fn.tempname()
    vim.fn.mkdir(dir, 'p')
    vim.fn.writefile({ 'no match here' }, dir .. '/start.txt')
    vim.fn.writefile({ 'alpha NEEDLE one' }, dir .. '/a.txt')
    vim.cmd('silent! only')
    vim.o.hidden = true
    vim.cmd('cd ' .. vim.fn.fnameescape(dir))
    vim.cmd('edit start.txt')
    vim.fn.setqflist({})

    vim.cmd('silent vimgrep /NEEDLE/ *.txt')

    assert(#vim.fn.getqflist() == 1, 'the list should hold the one match')
    assert(
      vim.fn.expand('%:t') == 'start.txt',
      ('you were thrown to %q -- the search should have left you where you were'):format(
        vim.fn.expand('%:t')
      )
    )
  end,
}
