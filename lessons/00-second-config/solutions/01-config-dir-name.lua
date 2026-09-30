return {
  goal = "Return the config directory's last path segment",
  hint = 'One function gives you the whole path; another trims a path down to its tail.',
  run = function()
    -- `:t` is the "tail" filename modifier -- lesson 21 covers the whole set.
    return vim.fn.fnamemodify(vim.fn.stdpath('config'), ':t')
  end,
  value = 'nvim',
}
