-- Drill 14. The other popup key. Open the popup and then CANCEL it, leaving the
-- partial word exactly as it was.
--
-- This is the behaviour people mistake for completion being flaky.
return {
  goal = 'Open the completion popup and cancel it, leaving "al" unchanged',
  hint = 'With the menu up: escape.',
  start = { 'alphabetical', 'al' },
  cursor = { 2, 1 },
  want = { 'alphabetical', 'al' },
  keys = 'A<C-n><C-e><Esc>',
}
