-- Drill 19. BUG HUNT -- starts FAILING. One character is wrong.
--
-- The intent is to open the completion popup and ACCEPT the match, finishing the
-- word. Run it: the popup was dismissed and "al" is still "al".
--
-- Both keys are documented and neither errors. They are adjacent on the keyboard
-- and they do opposite things while a menu is open.
return {
  goal = 'Open the completion popup and accept the selected match',
  hint = 'With the menu up, one of these two means yes and the other means escape.',
  start = { 'alphabetical', 'al' },
  cursor = { 2, 1 },
  want = { 'alphabetical', 'alphabetical' },
  keys = 'A<C-n><C-e><Esc>',
}
