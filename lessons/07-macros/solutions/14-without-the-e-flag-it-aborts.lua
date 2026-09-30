-- Drill 14. The same macro without that flag. Replay it three times and produce the
-- result it really gives -- the gap aborts it and the third line is untouched.
return {
  goal = 'Replay the flagless substitution macro and land its real result',
  hint = 'A substitution that matches nothing is an error, and an error aborts a macro.',
  start = { 'a;b', 'no-semi', 'c;d' },
  cursor = { 1, 0 },
  want = { 'ab', 'no-semi', 'c;d' },
  setup = function()
    vim.fn.setreg('s', ':s/;//\rj')
  end,
  keys = '3@s',
}
