-- Drill 08. A count on `iw` does NOT count words -- it steps through the strip of
-- alternating word / whitespace objects. Three of them starting at "one" are
-- "one", " ", "two". Predict the result before you run it, then check `want`.
return {
  goal = 'Delete three inner-word objects starting from "one"',
  hint = 'Count objects, not words. Whitespace runs are objects too.',
  start = { 'one two three four' },
  cursor = { 1, 0 },
  want = { ' three four' },
  keys = '', -- <- your answer
}
