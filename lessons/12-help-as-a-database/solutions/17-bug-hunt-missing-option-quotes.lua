return {
  goal = 'Resolve the help tag for the list OPTION, landing in options.txt',
  hint = 'Every Lookup table in this course writes option tags the same way.',
  check = function()
    -- An option's tag includes its quotes. Bare `list` is a real tag -- for the List
    -- data type -- so the lookup succeeds and quietly gives you the wrong page.
    local tag = "'list'"

    local ok = pcall(vim.cmd, 'help ' .. tag)
    assert(ok, ('the tag %q did not resolve at all'):format(tag))
    local landed = vim.fn.expand('%:t')
    pcall(vim.cmd, 'helpclose')
    assert(
      landed == 'options.txt',
      ('%q landed in %s -- that is not where options are documented'):format(tag, landed)
    )
  end,
}
