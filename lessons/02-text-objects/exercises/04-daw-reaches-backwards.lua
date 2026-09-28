-- Drill 04. This is the fix for lesson 01's stray-space footgun. The cursor is on
-- the last word of the line, so there is no trailing whitespace to take -- `aw`
-- takes the LEADING space instead. No motion can reach behind the cursor.
--
-- Compare: `dw` here left "the quick brown " with a trailing space.
return {
  goal = 'Delete the last word and the space before it',
  start = { 'the quick brown fox' },
  cursor = { 1, 16 },
  want = { 'the quick brown' },
  keys = '', -- <- your answer
}
