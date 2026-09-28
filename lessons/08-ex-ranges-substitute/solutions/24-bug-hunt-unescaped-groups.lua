return {
  goal = 'Swap the two words into "smith, john"',
  hint = 'Default pattern syntax does not treat bare ( as a group. Change the dialect.',
  start = { 'john smith' },
  cursor = { 1, 0 },
  want = { 'smith, john' },
  -- In the default dialect `(` is a literal parenthesis and `+` a literal plus, so
  -- the pattern matched nothing. `\v` -- very magic -- makes the pattern behave the
  -- way the other tools do, and keeps the backslashes out of the way once a pattern
  -- has more than one group.
  keys = ':s/\\v(\\w+) (\\w+)/\\2, \\1/<CR>',
}
