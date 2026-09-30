-- lua/hero/util.lua
--
-- Small helpers shared by the other modules. Returns a table, so callers do
-- `local util = require('hero.util')`.

local M = {}

--- Require a module that may legitimately be absent on this machine.
---
--- For the OPTIONAL case only -- a plugin you have not installed here, a work-only
--- module, anything behind a condition. Your own modules must NOT go through this: if
--- `hero.options` is missing then something is badly wrong and a loud failure is the
--- useful outcome. See the comment in `hero/init.lua`.
---
--- Reports at DEBUG rather than returning silently, because a guard that says nothing is
--- indistinguishable from a guard that never fired -- and keeps the error text, because
--- "not found" and "threw while loading" need different fixes.
---
---@param name string module name, as you would pass to require
---@return table|nil the module, or nil after reporting why
function M.optional(name)
  local ok, mod = pcall(require, name)
  if ok then
    return mod
  end

  vim.notify(('hero: optional module %s unavailable: %s'):format(name, mod), vim.log.levels.DEBUG)
  return nil
end

return M
