-- Drill 13. The worked example from the lesson. Replace the string contents and
-- leave both quotes standing. Getting this with `f` instead of `t` costs you the
-- closing quote.
return {
  goal = 'Replace the text between the quotes with goodbye, keeping both quotes',
  hint = 'Get inside the quotes first, then change with the exclusive motion.',
  start = { '    print("hello, world")' },
  cursor = { 1, 4 },
  want = { '    print("goodbye")' },
  keys = '', -- <- your answer
}
