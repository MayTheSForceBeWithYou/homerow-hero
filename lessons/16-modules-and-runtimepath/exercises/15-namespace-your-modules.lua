-- Drill 15. Why config/16 puts everything under `hero/`. A bare module name can collide
-- with any plugin shipping the same file; a namespaced one cannot.
--
-- Two fixtures both ship lua/options.lua. Return the require name that reaches YOURS
-- regardless of runtimepath order.
return {
  goal = 'Return a require name that cannot collide with a plugin shipping lua/options.lua',
  hint = 'Put it under a directory of your own.',
  check = function()
    local plugin, mine = vim.fn.tempname(), vim.fn.tempname()
    vim.fn.mkdir(plugin .. '/lua', 'p')
    vim.fn.mkdir(mine .. '/lua/d15hero', 'p')
    vim.fn.writefile({ "return { from = 'plugin' }" }, plugin .. '/lua/options.lua')
    vim.fn.writefile({ "return { from = 'mine' }" }, mine .. '/lua/d15hero/options.lua')
    -- The plugin is deliberately EARLIER on the runtimepath, so a bare name would lose.
    vim.opt.runtimepath:prepend(mine)
    vim.opt.runtimepath:prepend(plugin)

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    package.loaded[answer] = nil
    local ok, mod = pcall(require, answer)
    assert(ok, ('require(%q) failed: %s'):format(answer, tostring(mod)))
    assert(mod.from == 'mine', ("%q reached the plugin's module instead of yours"):format(answer))
  end,
}
