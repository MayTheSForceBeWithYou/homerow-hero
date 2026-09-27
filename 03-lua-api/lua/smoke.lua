-- Lesson 03: the buffer object model behind the capstone.
-- should_save() is the exact guard the capstone uses before compiling:
-- save only a normal file buffer (buftype == '') with unsaved changes.
local M = {}

---@param bufnr integer
---@return boolean
function M.should_save(bufnr)
  local bo = vim.bo[bufnr]
  return bo.modified and bo.buftype == ''
end

_G.homerow_hero = _G.homerow_hero or {}
_G.homerow_hero.should_save = M.should_save

vim.g.homerow_hero_lua_api_loaded = true

return M
