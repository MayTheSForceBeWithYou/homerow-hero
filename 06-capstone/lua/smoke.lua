-- Lesson 06 (capstone): save-if-modified before running external commands.
-- Saves the current buffer first, but only when it is a normal file buffer
-- with unsaved changes. Returns true when a write happened.
local M = {}

---@return boolean
function M.save_if_modified()
  if vim.bo.modified and vim.bo.buftype == '' then
    vim.cmd.write()
    return true
  end
  return false
end

_G.homerow_hero = _G.homerow_hero or {}
_G.homerow_hero.save_if_modified = M.save_if_modified

vim.g.homerow_hero_capstone_loaded = true

return M
