-- Drill 01. The exception to lesson 08. `:g` defaults to the WHOLE FILE, so this
-- works from the last line with no range at all.
--
-- If you add `%` it still works -- but notice you did not need it.
return {
  goal = 'Delete every line containing DROP, with the cursor on the last line',
  hint = 'No range needed. What is :g default?',
  start = { 'keep 1', 'DROP a', 'keep 2', 'DROP b', 'keep 3' },
  cursor = { 5, 0 },
  want = { 'keep 1', 'keep 2', 'keep 3' },
  keys = '', -- <- your answer
}
