return {
  goal = 'Return whether $MYVIMRC is unset in this session',
  hint = 'vim.env is the table of environment variables; an unset one is nil.',
  run = function()
    return vim.env.MYVIMRC == nil
  end,
  value = true,
}
