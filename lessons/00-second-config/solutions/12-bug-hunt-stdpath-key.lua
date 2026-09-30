return {
  goal = 'Return the directory where plugins are installed',
  hint = 'stdpath() accepts a fixed set of keys. Which one means "installed things"?',
  run = function()
    -- There is no 'plugins' key: Neovim answered
    --   E6100: "plugins" is not a valid stdpath
    -- Plugins are installed content, so they live under 'data'.
    return vim.fn.stdpath('data')
  end,
  value = vim.fn.stdpath('data'),
}
