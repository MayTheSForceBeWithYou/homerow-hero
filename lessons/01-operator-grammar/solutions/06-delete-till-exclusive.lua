-- Drill 06. Same target character, the exclusive motion. One character of
-- difference from drill 05 -- compare the two `want` values.
return {
  goal = 'Delete up to but not including the first "o"',
  hint = 'Think of it as "till".',
  start = { 'the quick brown fox' },
  cursor = { 1, 0 },
  want = { 'own fox' },
  keys = 'dto',
}
