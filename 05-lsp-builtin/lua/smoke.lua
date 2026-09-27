-- Lesson 05: the built-in LSP client surface (Neovim 0.12 / nightly).
-- Pin the entry points here so CI fails fast on nightly API renames.
--
-- NOTE: on 0.11/0.12 vim.lsp.config was a plain function; on 0.13-dev it is a
-- callable table. Test callability, not type.
local M = {}

local function is_callable(x)
  if type(x) == 'function' then
    return true
  end
  local mt = type(x) == 'table' and getmetatable(x)
  return mt ~= nil and type(mt.__call) == 'function'
end

M.has_config = is_callable(vim.lsp.config)
M.has_enable = type(vim.lsp.enable) == 'function'

vim.g.homerow_hero_lsp_builtin_loaded = true

return M
