-- Drill 16. `:cdo` runs once per ENTRY and `:cfdo` once per FILE. With a whole-file
-- substitution, :cfdo does the same work in fewer passes.
--
-- Return the command name -- without a colon -- that iterates once per file.
return {
  goal = 'Return the quickfix iteration command that runs once per file',
  run = function()
    return nil -- <- your answer
  end,
  value = 'cfdo',
}
