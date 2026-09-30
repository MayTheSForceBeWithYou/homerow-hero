-- Drill 09. $MYVIMRC names the config file Neovim actually loaded. The lesson
-- used it as the check for "no config file was found at all".
--
-- This session runs with `-u NONE`, so no config was loaded. Return true if
-- $MYVIMRC is unset. Read it through Neovim's environment table, not os.getenv.
return {
  goal = 'Return whether $MYVIMRC is unset in this session',
  hint = 'vim.env is the table of environment variables; an unset one is nil.',
  run = function()
    return nil -- <- your answer
  end,
  value = true,
}
