-- Drill 07. `gi` jumps to where Insert mode was last left AND re-enters Insert
-- there. Append "one" to line 1, go away, then resume and add "two" -- with no
-- navigation back.
return {
  goal = 'Append "one" to line 1, move to the last line, then resume typing "two" where you stopped',
  hint = 'One command both jumps and re-enters Insert mode.',
  start = { 'start ', 'other', 'last' },
  cursor = { 1, 0 },
  want = { 'start onetwo', 'other', 'last' },
  keys = '', -- <- your answer
}
