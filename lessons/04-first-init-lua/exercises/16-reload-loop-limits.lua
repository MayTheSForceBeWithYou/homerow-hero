-- Drill 16. Recall with a reason. Two features make `:source %` stop being
-- equivalent to restarting Neovim. Return them as a sorted list of two strings,
-- exactly: 'autocommands' and 'modules'.
return {
  goal = 'Return the two features that break the re-source loop',
  hint = 'One is cached and will not re-run; the other accumulates duplicates.',
  run = function()
    return nil -- <- your answer
  end,
  value = { 'autocommands', 'modules' },
}
