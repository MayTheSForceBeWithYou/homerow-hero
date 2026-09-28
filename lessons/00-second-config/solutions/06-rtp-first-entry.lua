return {
  goal = 'Return whether the first runtimepath entry is the config directory',
  hint = 'Lua indexes lists from 1.',
  run = function()
    local entries = vim.split(vim.o.runtimepath, ',')
    return entries[1] == vim.fn.stdpath('config')
  end,
  value = true,
}
