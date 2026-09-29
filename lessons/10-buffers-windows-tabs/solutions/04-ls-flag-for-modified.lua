-- Drill 04. Return the character that appears in the last flag column of a `:ls`
-- listing for a buffer with unsaved changes -- the one you scan for when you have
-- lost track of your work.
return {
  goal = 'Return the :ls flag character meaning "modified"',
  run = function()
    return '+' -- <- your answer
  end,
  value = '+',
}
