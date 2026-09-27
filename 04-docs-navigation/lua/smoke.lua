-- Lesson 04: :help is queryable. getcompletion() with the 'help' type
-- searches the help tags, so documentation lookup is scriptable.
local M = {}

---@param prefix string
---@return string[] matching help tags
function M.help_tags_for(prefix)
  return vim.fn.getcompletion(prefix, 'help')
end

_G.homerow_hero = _G.homerow_hero or {}
_G.homerow_hero.help_tags_for = M.help_tags_for

vim.g.homerow_hero_docs_navigation_loaded = true

return M
