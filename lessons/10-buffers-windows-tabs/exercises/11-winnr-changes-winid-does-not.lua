-- Drill 11. Two ways to name a window. One is the position in the layout and changes
-- when the layout does; the other is permanent for the session.
--
-- Return the name of the function giving the PERMANENT one, as a string like 'foo()'.
return {
  goal = 'Return the function that yields a permanent window identifier',
  hint = 'One of these two is described by :h window-ID and the other by :h window-number.',
  run = function()
    return nil -- <- your answer
  end,
  value = 'win_getid()',
}
