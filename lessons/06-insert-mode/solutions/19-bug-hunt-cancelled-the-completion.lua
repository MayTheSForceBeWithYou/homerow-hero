return {
  goal = 'Open the completion popup and accept the selected match',
  hint = 'With the menu up, one of these two means yes and the other means escape.',
  start = { 'alphabetical', 'al' },
  cursor = { 2, 1 },
  want = { 'alphabetical', 'alphabetical' },
  -- `<C-e>` cancels an open popup -- documented behaviour, and the thing people
  -- mistake for completion being flaky. `<C-y>` accepts: with the menu up, yes.
  keys = 'A<C-n><C-y><Esc>',
}
