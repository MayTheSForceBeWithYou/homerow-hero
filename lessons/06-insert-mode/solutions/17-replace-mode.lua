-- Drill 17. Replace mode overwrites rather than inserts.
return {
  goal = 'Overwrite the first two characters with XY',
  start = { 'abcdef' },
  cursor = { 1, 0 },
  want = { 'XYcdef' },
  keys = 'RXY<Esc>',
}
