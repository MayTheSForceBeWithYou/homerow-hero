-- Drill 12. Do not count the lines. An abort discards the remaining count, so a
-- deliberately huge number runs until something stops it.
--
-- The fourth line has no semicolon, so the macro stops there and the fifth line is
-- never reached.
return {
  goal = 'Run the anchored macro with a count of 99 and let it stop where it should',
  hint = 'You are not expected to know how many lines there are.',
  start = { 'a;', 'b;', 'c;', 'no', 'd;' },
  cursor = { 1, 0 },
  want = { 'a', 'b', 'c', 'no', 'd;' },
  setup = function()
    vim.fn.setreg('a', '0f;xj')
  end,
  keys = '', -- <- your answer
}
