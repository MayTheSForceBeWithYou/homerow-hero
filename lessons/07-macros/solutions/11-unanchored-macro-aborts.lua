-- Drill 11. The failure itself, so you can recognise it. Replay the UNANCHORED
-- macro three times and produce the result it actually gives -- one line changed,
-- two silently untouched.
--
-- Predicting this correctly is the drill.
return {
  goal = 'Replay the unanchored macro three times and land its real result',
  hint = 'It does not fail to run. It runs, and the second repetition aborts.',
  start = { 'a;b', 'c;d', 'e;f' },
  cursor = { 1, 0 },
  want = { 'ab', 'c;d', 'e;f' },
  setup = function()
    vim.fn.setreg('q', 'f;xj')
  end,
  keys = '3@q',
}
