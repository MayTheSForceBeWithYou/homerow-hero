-- Drill 05. A function's tag carries its parentheses. Return the tag for the Lua
-- function that sets a keymap.
return {
  goal = 'Return the help tag for the Lua keymap-setting function',
  hint = 'Exactly as you would call it, parentheses and all.',
  run = function()
    return nil -- <- your answer
  end,
  value = 'vim.keymap.set()',
}
