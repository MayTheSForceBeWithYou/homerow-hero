-- Drill 17. The lesson-01 worked example, done properly. Five keystrokes there,
-- three here -- and unlike `f"lct"`, this works from column 1.
return {
  goal = 'Replace the string contents with bye, starting from column 1',
  start = { 'say "hi there" now' },
  cursor = { 1, 0 },
  want = { 'say "bye" now' },
  keys = 'ci"bye<Esc>',
}
