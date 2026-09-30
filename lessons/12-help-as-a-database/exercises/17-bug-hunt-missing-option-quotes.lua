-- Drill 17. BUG HUNT -- starts FAILING.
--
-- The intent is to open the documentation for the `list` OPTION. Run it: the tag
-- resolves, no error is raised, and you land on the wrong page entirely -- the
-- documentation for Vim's List data type.
--
-- This is the failure the lesson calls a query problem rather than a documentation
-- problem. Two characters fix it.
return {
  goal = 'Resolve the help tag for the list OPTION, landing in options.txt',
  hint = 'Every Lookup table in this course writes option tags the same way.',
  check = function()
    local tag = 'list'

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
