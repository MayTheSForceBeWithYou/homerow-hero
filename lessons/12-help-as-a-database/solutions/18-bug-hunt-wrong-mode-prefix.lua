return {
  goal = 'Resolve the Insert-mode CTRL-W tag, landing in insert.txt',
  hint = 'Two characters at the front.',
  check = function()
    -- Bare `CTRL-W` is the Normal-mode window prefix, documented in index.txt. The
    -- mode prefix selects which of the three CTRL-W pages you get.
    local tag = 'i_CTRL-W'

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
