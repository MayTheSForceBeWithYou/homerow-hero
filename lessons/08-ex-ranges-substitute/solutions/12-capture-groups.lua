-- Drill 12. Swap two words using capture groups, in the DEFAULT pattern syntax --
-- which means the parentheses need escaping.
return {
  goal = 'Swap the two words into "smith, john" using escaped capture groups',
  hint = 'In default syntax a group is \\( ... \\)',
  start = { 'john smith' },
  cursor = { 1, 0 },
  want = { 'smith, john' },
  keys = ':s/\\(\\w\\+\\) \\(\\w\\+\\)/\\2, \\1/<CR>',
}
