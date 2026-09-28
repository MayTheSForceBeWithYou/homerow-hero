-- Drill 07. A count on `aw` counts words the way you expect.
return {
  goal = 'Delete the first two words and their spaces',
  start = { 'one two three four' },
  cursor = { 1, 0 },
  want = { 'three four' },
  keys = '2daw',
}
