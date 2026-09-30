-- Drill 02. The inverse: act on lines that do NOT match. Keep only the lines
-- containing "keep" by deleting everything else.
return {
  goal = 'Delete every line that does not contain "keep"',
  hint = 'One letter instead of g, or g with a bang.',
  start = { 'keep 1', 'DROP a', 'keep 2', 'DROP b', 'keep 3' },
  cursor = { 1, 0 },
  want = { 'keep 1', 'keep 2', 'keep 3' },
  keys = '', -- <- your answer
}
