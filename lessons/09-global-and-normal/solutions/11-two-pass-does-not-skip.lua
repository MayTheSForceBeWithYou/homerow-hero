-- Drill 11. Deleting lines while walking through them ought to skip every other one.
-- It does not, because :g marks all the matching lines BEFORE executing anything.
--
-- Delete five consecutive matching lines and confirm none survive. An empty buffer
-- still contains one empty line, which is why `want` is a single empty string.
return {
  goal = 'Delete five consecutive matching lines, leaving none behind',
  start = { 'x1', 'x2', 'x3', 'x4', 'x5' },
  cursor = { 1, 0 },
  want = { '' },
  keys = ':g/x/d _<CR>',
}
