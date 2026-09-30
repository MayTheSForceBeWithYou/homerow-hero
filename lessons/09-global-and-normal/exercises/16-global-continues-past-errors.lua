-- Drill 16. The documented contrast with lesson 07. Lines 2 and 4 have no semicolon,
-- so the operation fails on them.
--
-- A macro would abort at line 2. `:g` logs the error and carries on, so lines 3 and 5
-- are still processed. Produce that result.
return {
  goal = 'Delete the character after the semicolon on every line, continuing past failures',
  hint = 'Match every line with a dot, and let :g absorb the errors.',
  start = { 'a;1', 'no2', 'b;3', 'no4', 'c;5' },
  cursor = { 1, 0 },
  want = { 'a1', 'no2', 'b3', 'no4', 'c5' },
  keys = '', -- <- your answer
}
