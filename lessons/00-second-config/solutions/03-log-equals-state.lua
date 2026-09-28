return {
  goal = 'Return whether the log directory is the same as the state directory',
  run = function()
    -- stdpath('log') is not a directory of its own; it aliases state.
    return vim.fn.stdpath('log') == vim.fn.stdpath('state')
  end,
  value = true,
}
