-- Drill 15. While typing a `:help` argument, one key inserts the first completion and
-- another LISTS all of them without inserting anything.
--
-- Return the listing key, written as you would in a mapping.
return {
  goal = 'Return the command-line key that lists completions without inserting one',
  run = function()
    return nil -- <- your answer
  end,
  value = '<C-d>',
}
