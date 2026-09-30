-- Drill 08. Insert the same text twice without retyping it and without using a
-- register name.
return {
  goal = 'Type FOO, then insert the same text again on a new line',
  hint = 'One key inserts whatever you last typed in Insert mode.',
  start = { 'x' },
  cursor = { 1, 0 },
  want = { 'FOOx', 'FOO' },
  keys = 'iFOO<Esc>o<C-a><Esc>',
}
