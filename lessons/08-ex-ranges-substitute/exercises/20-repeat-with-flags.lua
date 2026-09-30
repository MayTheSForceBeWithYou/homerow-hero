-- Drill 20. Repeat the previous substitution on another line, KEEPING its flags.
-- The plain repeat command drops them, which is why a repeat sometimes changes only
-- the first match.
return {
  goal = 'Substitute on line 1 with the g flag, then repeat it on line 2 with flags kept',
  hint = 'The plain repeat is one character; the flag-preserving one is a colon command.',
  start = { 'a a', 'a a' },
  cursor = { 1, 0 },
  want = { 'X X', 'X X' },
  keys = '', -- <- your answer
}
