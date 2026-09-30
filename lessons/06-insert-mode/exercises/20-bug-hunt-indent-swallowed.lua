-- Drill 20. BUG HUNT -- starts FAILING.
--
-- The intent is to put a comment marker at the very start of the line, flush left,
-- regardless of how the line is indented. Run it: the marker landed after the
-- indentation instead of before it.
--
-- Two keys enter Insert mode at the beginning of a line. They disagree about what
-- "the beginning" means.
return {
  goal = 'Insert "# " at column 1, before the indentation',
  hint = 'One of the pair respects indentation. You want the one that does not.',
  start = { '    local x = 1' },
  cursor = { 1, 10 },
  want = { '#     local x = 1' },
  keys = 'I# <Esc>',
}
