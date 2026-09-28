-- Drill 10. Delete two lines *using a motion* rather than a doubled operator.
-- The result proves the motion is linewise: both lines vanish completely, not
-- just the characters between the two cursor positions.
return {
  goal = 'Delete two lines using an operator and a downward motion',
  start = { 'one', 'two', 'three', 'four' },
  cursor = { 1, 0 },
  want = { 'three', 'four' },
  keys = '', -- <- your answer
}
