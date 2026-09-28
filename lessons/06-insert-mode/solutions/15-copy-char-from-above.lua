-- Drill 15. The SAME key as drill 13, with no popup open, does something unrelated:
-- it copies the character directly above the cursor. Press it twice to copy two.
return {
  goal = 'With no popup open, copy two characters from the line above',
  hint = 'Same key as drill 13. No menu is open, so it means the other thing.',
  start = { 'ABCDEF', 'x' },
  cursor = { 2, 0 },
  want = { 'ABCDEF', 'xBC' },
  keys = 'A<C-y><C-y><Esc>',
}
