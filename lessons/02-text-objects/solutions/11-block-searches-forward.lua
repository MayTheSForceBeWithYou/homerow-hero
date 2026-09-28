-- Drill 11. The cursor is at column 1, OUTSIDE the parentheses entirely. This
-- still works, because `:h ib` says that when the cursor is not inside a ()
-- block the object finds the next "(" on the line.
--
-- This is why `ci(` is safe to press without navigating first.
return {
  goal = 'Empty the parentheses starting from column 1, outside them',
  start = { 'abc def (bar) ghi' },
  cursor = { 1, 0 },
  want = { 'abc def () ghi' },
  keys = 'di(',
}
