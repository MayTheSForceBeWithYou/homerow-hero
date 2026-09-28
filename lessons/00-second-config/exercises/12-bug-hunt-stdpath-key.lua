-- Drill 12. BUG HUNT -- this one starts FAILING, and it fails by *raising*, not
-- by returning something wrong. Read the error the runner prints; Neovim names
-- the problem precisely.
--
-- The intent is to return the directory where plugins get installed.
return {
  goal = 'Return the directory where plugins are installed',
  hint = 'stdpath() accepts a fixed set of keys. Which one means "installed things"?',
  run = function()
    return vim.fn.stdpath('plugins')
  end,
  value = vim.fn.stdpath('data'),
}
