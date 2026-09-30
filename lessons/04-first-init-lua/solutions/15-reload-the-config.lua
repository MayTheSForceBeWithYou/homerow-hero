-- Drill 15. The reload loop. Return the Ex command that re-runs the file you are
-- currently editing, using the shorthand for "the current file" rather than a
-- path.
return {
  goal = 'Return the Ex command that re-runs the file currently being edited',
  hint = 'Two characters after the command name.',
  run = function()
    return 'source %' -- <- your answer
  end,
  value = 'source %',
}
