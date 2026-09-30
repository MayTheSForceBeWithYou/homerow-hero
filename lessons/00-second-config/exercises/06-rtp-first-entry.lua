-- Drill 06. The lesson's recognition rule: the runtimepath is searched in order,
-- and your config directory is first. Return true if the first runtimepath entry
-- really is the config directory.
--
-- `vim.o.runtimepath` is one comma-separated string, not a list. You will need
-- to split it -- `vim.split(s, ',')` does that.
return {
  goal = 'Return whether the first runtimepath entry is the config directory',
  hint = 'Lua indexes lists from 1.',
  run = function()
    return nil -- <- your answer
  end,
  value = true,
}
