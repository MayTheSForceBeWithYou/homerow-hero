-- Drill 14. `gU` is an operator, so it composes with motions exactly like `d`.
-- Uppercase the first word only -- the space after it must not be touched
-- (uppercasing a space is invisible, so use the inclusive motion on principle).
return {
  goal = 'Uppercase the first word',
  start = { 'the quick brown fox' },
  cursor = { 1, 0 },
  want = { 'THE quick brown fox' },
  keys = 'gUe',
}
