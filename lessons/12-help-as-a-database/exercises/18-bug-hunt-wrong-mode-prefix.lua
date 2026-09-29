-- Drill 18. BUG HUNT -- starts FAILING.
--
-- The intent is the INSERT-mode documentation for CTRL-W -- the delete-word-back key
-- from lesson 06. Run it: you land on the window-command page instead, because the
-- bare tag is the Normal-mode meaning.
--
-- A control key is documented once per mode, and the mode is part of the tag.
return {
  goal = 'Resolve the Insert-mode CTRL-W tag, landing in insert.txt',
  hint = 'Two characters at the front.',
  check = function()
    local tag = 'CTRL-W'

    local ok = pcall(vim.cmd, 'help ' .. tag)
    assert(ok, ('the tag %q did not resolve at all'):format(tag))
    local landed = vim.fn.expand('%:t')
    pcall(vim.cmd, 'helpclose')
    assert(
      landed == 'insert.txt',
      ('%q landed in %s -- that is the wrong mode'):format(tag, landed)
    )
  end,
}
