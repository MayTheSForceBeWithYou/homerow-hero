-- Drill 20. Recall. At a terminal, forward-jumping shares a byte with another key,
-- so mapping that key in Normal mode silently breaks the jumplist.
--
-- Return the name of that key, spelled the way you would write it in a mapping.
return {
  goal = 'Return the key that shares a byte with the forward-jump command',
  run = function()
    return nil -- <- your answer
  end,
  value = '<Tab>',
}
