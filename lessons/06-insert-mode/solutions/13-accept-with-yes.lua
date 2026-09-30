-- Drill 13. With a popup open, one key accepts the selected match. Away from a
-- popup that same key copies the character above -- this drill is the popup case.
return {
  goal = 'Open the completion popup and accept the selected match',
  hint = 'With the menu up: yes.',
  start = { 'alphabetical', 'al' },
  cursor = { 2, 1 },
  want = { 'alphabetical', 'alphabetical' },
  keys = 'A<C-n><C-y><Esc>',
}
