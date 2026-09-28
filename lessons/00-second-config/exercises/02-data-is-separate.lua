-- Drill 02. The lesson claims config and data are different directories, and
-- that this is what makes NVIM_APPNAME real isolation rather than cosmetic.
-- Prove it: return true if they differ, false if they are the same.
return {
  goal = 'Return whether the data directory differs from the config directory',
  run = function()
    return nil -- <- your answer
  end,
  value = true,
}
