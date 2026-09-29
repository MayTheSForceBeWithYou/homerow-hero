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

    -- Without `j`, :vimgrep jumps to the first match the moment it finishes -- which
    -- loses your place before you have read the list.
    vim.cmd('silent vimgrep /NEEDLE/j *.txt')

    assert(#vim.fn.getqflist() == 1, 'the list should hold the one match')
    assert(
      vim.fn.expand('%:t') == 'start.txt',
      ('you were thrown to %q -- the search should have left you where you were'):format(
        vim.fn.expand('%:t')
      )
    )
  end,
}
