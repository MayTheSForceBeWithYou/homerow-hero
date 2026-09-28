return {
  goal = 'Return whether this Neovim is at least version 0.12, as a boolean',
  hint = 'has() answers with 1 or 0.',
  run = function()
    -- In Lua, 0 is truthy -- only nil and false are falsy. So `if has(..)` would
    -- be true even for an unsupported feature. Compare against 1 explicitly.
    return vim.fn.has('nvim-0.12') == 1
  end,
  value = true,
}
