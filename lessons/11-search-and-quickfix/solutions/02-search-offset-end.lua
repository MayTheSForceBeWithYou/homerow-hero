-- Drill 02. An offset moves where the search leaves you. Land at the END of the match
-- instead, then delete to the end of the line -- so the matched word survives.
--
-- Compare the result with drill 01: same search, one offset apart.
return {
  goal = 'Search for NEEDLE, land at the end of the match, and delete the rest of the line',
  hint = 'Append a slash and one letter to the search.',
  start = { 'alpha NEEDLE one' },
  cursor = { 1, 0 },
  want = { 'alpha NEEDL' },
  keys = '/NEEDLE/e<CR>D',
}
