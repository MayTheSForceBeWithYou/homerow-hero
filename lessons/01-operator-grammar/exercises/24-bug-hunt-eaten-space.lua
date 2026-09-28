-- Drill 24. BUG HUNT -- starts FAILING. One keystroke is wrong.
--
-- The intent is to delete the word `alpha` and leave the spacing untouched, so
-- that `beta` stays where it was. Run it: the words have been pulled together.
--
-- This is the distinction from drills 01 and 02, met in the wild.
return {
  goal = 'Delete "alpha" without disturbing the space that followed it',
  hint = 'Which word motion stops *on* the last character of the word?',
  start = { 'alpha beta gamma' },
  cursor = { 1, 0 },
  want = { ' beta gamma' },
  keys = 'dw',
}
