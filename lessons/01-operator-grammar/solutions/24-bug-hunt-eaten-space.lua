return {
  goal = 'Delete "alpha" without disturbing the space that followed it',
  hint = 'Which word motion stops *on* the last character of the word?',
  start = { 'alpha beta gamma' },
  cursor = { 1, 0 },
  want = { ' beta gamma' },
  -- `w` is exclusive and lands on `b`, so `dw` took the separating space with it.
  -- `e` is inclusive: it lands on the final `a` of alpha and stops there.
  keys = 'de',
}
