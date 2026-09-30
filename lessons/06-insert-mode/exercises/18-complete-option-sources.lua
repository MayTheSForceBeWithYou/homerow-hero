-- Drill 18. Return the name of the option that decides WHERE keyword completion
-- looks for matches -- just the option name, no quotes and no colon.
return {
  goal = 'Return the option controlling where keyword completion searches',
  hint = 'The other candidate controls how the menu behaves, not where matches come from.',
  run = function()
    return nil -- <- your answer
  end,
  value = 'complete',
}
