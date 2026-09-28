-- Drill 02. The other one. Enter Insert mode at column 1, IGNORING the
-- indentation, so the marker sits flush left.
--
-- Compare the result with drill 01: same buffer, same goal text, one key apart.
return {
  goal = 'Insert "# " at column 1, ignoring the indentation',
  hint = 'One key is the indent-respecting version; you want the other.',
  start = { '    local x = 1' },
  cursor = { 1, 10 },
  want = { '#     local x = 1' },
  keys = 'gI# <Esc>',
}
