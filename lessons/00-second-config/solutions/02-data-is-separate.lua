return {
  goal = 'Return whether the data directory differs from the config directory',
  run = function()
    return vim.fn.stdpath('data') ~= vim.fn.stdpath('config')
  end,
  value = true,
}
