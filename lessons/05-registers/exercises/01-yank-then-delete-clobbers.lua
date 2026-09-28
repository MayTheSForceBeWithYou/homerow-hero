-- Drill 01. The frustration itself, made concrete. Yank the first line, delete the
-- second, then put -- and watch the WRONG text arrive. The `want` below is what
-- actually happens, not what you hoped for.
--
-- Nothing here is broken. Your job is to predict it correctly.
return {
  goal = 'Yank line 1, delete line 2, then put -- and land the deleted line',
  hint = 'Both operations write to the same register. Which one was last?',
  start = { 'KEEP', 'GONE', 'tail' },
  cursor = { 1, 0 },
  want = { 'KEEP', 'tail', 'GONE' },
  keys = '', -- <- your answer
}
