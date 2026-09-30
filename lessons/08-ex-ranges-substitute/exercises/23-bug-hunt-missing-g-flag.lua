-- Drill 23. BUG HUNT -- starts FAILING. One character is missing.
--
-- The intent is to replace every "a" everywhere in the file. Run it: every line was
-- visited, but only the first match on each line changed.
--
-- The range is correct. Ask what the range chooses, and what chooses how many
-- matches within each line it visits.
return {
  goal = 'Replace every "a" on every line',
  hint = 'Two independent ideas. You have supplied one of them.',
  start = { 'a a', 'a a', 'a a' },
  cursor = { 1, 0 },
  want = { 'X X', 'X X', 'X X' },
  keys = ':%s/a/X/<CR>',
}
