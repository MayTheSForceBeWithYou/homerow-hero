-- Drill 01. Enter Insert mode before the first non-blank character, respecting the
-- indentation, and type a comment marker.
return {
  goal = 'Insert "-- " before the first non-blank, keeping the indentation',
  start = { '    local x = 1' },
  cursor = { 1, 10 },
  want = { '    -- local x = 1' },
  keys = 'I-- <Esc>',
}
