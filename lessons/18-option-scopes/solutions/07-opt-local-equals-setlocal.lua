-- Drill 07. Map each Lua writer to its Ex command. Return the Ex command name -- without a
-- colon -- that `vim.opt_local` corresponds to.
return {
  goal = 'Return the Ex command vim.opt_local is equivalent to',
  run = function()
    return 'setlocal' -- <- your answer
  end,
  value = 'setlocal',
}
