-- Drill 03. A bare number in an offset is a LINE offset, which makes the search a
-- line-oriented motion. Land on the line after the match and delete that line.
return {
  goal = 'Search for NEEDLE, move one line past it, and delete that line',
  hint = 'The offset is just a signed number.',
  start = { 'alpha', 'beta NEEDLE', 'gamma', 'delta' },
  cursor = { 1, 0 },
  want = { 'alpha', 'beta NEEDLE', 'delta' },
  keys = '/NEEDLE/+1<CR>dd',
}
