-- Drill 13. Recall with a consequence. Two command-line flags run Ex commands at
-- startup: one at step 3 (before your config) and one after step 8 (after it).
--
-- Return the flag -- as the exact string you would type on the command line --
-- that runs *before* your config is read.
return {
  goal = 'Return the command-line flag that runs a command before your config loads',
  run = function()
    return nil -- <- your answer
  end,
  value = '--cmd',
}
