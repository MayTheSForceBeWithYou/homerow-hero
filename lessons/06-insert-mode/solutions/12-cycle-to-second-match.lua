-- Drill 12. Two candidates share the prefix, so a popup appears and the first match
-- is pre-selected. Reach the SECOND one.
return {
  goal = 'Complete "al" to "album" when "alpha" is the first match',
  hint = 'The same key cycles.',
  start = { 'alpha', 'album', 'al' },
  cursor = { 3, 1 },
  want = { 'alpha', 'album', 'album' },
  keys = 'A<C-n><C-n><Esc>',
}
