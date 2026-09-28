-- Drill 05. Recall. Neovim refuses to start when both init.lua and init.vim
-- exist in the config directory. Return the error *number* it prints, as a
-- string including the leading E -- for example 'E999'.
return {
  goal = 'Return the error number for having both init.lua and init.vim',
  run = function()
    return nil -- <- your answer
  end,
  value = 'E5422',
}
