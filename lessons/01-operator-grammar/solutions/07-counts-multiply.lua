-- Drill 07. Two counts, one command. Delete six words using a count on *both*
-- sides of the operator -- do not write `d6w`.
return {
  goal = 'Delete six words with a count on each side of the operator',
  hint = '2 and 3 multiply.',
  start = { 'a1 a2 a3 a4 a5 a6 a7' },
  cursor = { 1, 0 },
  want = { 'a7' },
  keys = '2d3w',
}
