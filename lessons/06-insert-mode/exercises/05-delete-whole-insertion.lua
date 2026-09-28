-- Drill 05. Abandon everything typed in this insertion, without leaving Insert
-- mode and without touching the text that was already on the line.
--
-- Note that the original "x" survives: the key deletes back to where the insertion
-- began, not to the start of the line.
return {
  goal = 'Discard the entire current insertion, then type something else',
  start = { 'x' },
  cursor = { 1, 0 },
  want = { 'ENDx' },
  keys = '', -- <- your answer
}
