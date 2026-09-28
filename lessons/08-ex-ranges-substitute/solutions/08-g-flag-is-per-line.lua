-- Drill 08. Without the g flag a substitution replaces the FIRST match on each line
-- it visits. Produce that result deliberately on a line with three matches.
return {
  goal = 'Replace only the first "a" on the line',
  start = { 'a a a' },
  cursor = { 1, 0 },
  want = { 'X a a' },
  keys = ':s/a/X/<CR>',
}
