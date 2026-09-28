-- Drill 03. The lesson flagged two stdpath rows as surprising. One of them is
-- that a certain key does not get its own directory -- it resolves to the same
-- place as another key. Return true if those two keys are equal.
--
-- If you pick the wrong pair this returns false and the drill fails, which is
-- the point: go back to the stdpath table in the lesson.
return {
  goal = 'Return whether the log directory is the same as the state directory',
  run = function()
    return nil -- <- your answer
  end,
  value = true,
}
