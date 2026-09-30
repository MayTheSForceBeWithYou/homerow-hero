-- Drill 24. BUG HUNT -- starts FAILING.
--
-- The intent is to swap two words. The pattern is written the way it would be in
-- most other tools, with bare parentheses for groups -- and it matches nothing, so
-- the line is unchanged.
--
-- There are two ways to fix this. One escapes each parenthesis; the other switches
-- the whole pattern to a different dialect with two characters at the front. Use the
-- second -- the lesson says why it is worth preferring.
return {
  goal = 'Swap the two words into "smith, john"',
  hint = 'Default pattern syntax does not treat bare ( as a group. Change the dialect.',
  start = { 'john smith' },
  cursor = { 1, 0 },
  want = { 'smith, john' },
  keys = ':s/(\\w+) (\\w+)/\\2, \\1/e<CR>',
}
