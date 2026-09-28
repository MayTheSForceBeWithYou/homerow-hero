-- Drill 09. And the copy version, which leaves the originals in place.
return {
  goal = 'Copy every line containing "keep" to the end of the file',
  hint = 'One letter, and it is not m.',
  start = { 'keep a', 'x', 'keep b' },
  cursor = { 1, 0 },
  want = { 'keep a', 'x', 'keep b', 'keep a', 'keep b' },
  keys = '', -- <- your answer
}
