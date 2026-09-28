-- Drill 22. A paragraph is a run of non-blank lines. `ip` takes the lines and
-- leaves the blank separator standing.
return {
  goal = 'Delete the first paragraph, leaving the blank line',
  start = { 'p1a', 'p1b', '', 'p2' },
  cursor = { 1, 0 },
  want = { '', 'p2' },
  keys = 'dip',
}
