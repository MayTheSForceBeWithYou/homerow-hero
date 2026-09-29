-- Drill 17. A second search REPLACES the quickfix list. Return the command name --
-- without a colon -- that appends to the existing list instead.
return {
  goal = 'Return the command that appends to the quickfix list rather than replacing it',
  hint = 'It is the external-grep command with a suffix.',
  run = function()
    return nil -- <- your answer
  end,
  value = 'grepadd',
}
