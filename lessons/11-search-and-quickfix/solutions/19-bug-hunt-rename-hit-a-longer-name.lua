return {
  goal = 'Rename old_name without also renaming old_name_helper',
  hint = 'Two escapes, one either side of the pattern.',
  check = function()
    local dir = vim.fn.tempname()
    vim.fn.mkdir(dir, 'p')
    vim.fn.writefile({ 'call old_name()', 'call old_name_helper()' }, dir .. '/a.txt')
    vim.cmd('silent! only')
    vim.o.hidden = true
    vim.cmd('cd ' .. vim.fn.fnameescape(dir))
    vim.fn.setqflist({})
    vim.cmd('silent vimgrep /old_name/j a.txt')

    -- Word boundaries. Without them the substitution matches the prefix of a longer
    -- identifier, which is the quiet half of a botched rename -- the code still
    -- compiles in many languages and simply calls something that is not there.
    vim.cmd('silent cdo s/\\<old_name\\>/new_name/ge | update')

    local lines = vim.fn.readfile(dir .. '/a.txt')
    assert(lines[1] == 'call new_name()', ('line 1 is %q'):format(lines[1]))
    assert(
      lines[2] == 'call old_name_helper()',
      ('line 2 should be untouched, is %q'):format(lines[2])
    )
  end,
}
