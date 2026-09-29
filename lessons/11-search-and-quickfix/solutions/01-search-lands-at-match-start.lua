-- Drill 01. The default: a search leaves the cursor on the FIRST character of the
-- match. Delete from there to the end of the line to prove where it landed.
return {
  goal = 'Search for NEEDLE and delete from the match start to the end of the line',
  start = { 'alpha NEEDLE one' },
  cursor = { 1, 0 },
  want = { 'alpha ' },
  keys = '/NEEDLE<CR>D',
}
