-- Drill 17. Same result as drill 16, written honestly. Instead of matching every line
-- and relying on errors being ignored, select exactly the lines that have a semicolon.
--
-- The lesson argues for this version: a pattern documents intent, error tolerance
-- hides mistakes.
return {
  goal = 'Do the same edit, but select only the lines that actually have a semicolon',
  hint = 'Put the thing you depend on into the pattern.',
  start = { 'a;1', 'no2', 'b;3', 'no4', 'c;5' },
  cursor = { 1, 0 },
  want = { 'a1', 'no2', 'b3', 'no4', 'c5' },
  keys = '', -- <- your answer
}
