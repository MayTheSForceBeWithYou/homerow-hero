-- Drill 18. BUG HUNT -- starts FAILING.
--
-- The file exists at lua/d18ns/thing.lua, it is on the runtimepath, and require reports
-- "module not found" along with a long list of paths.
--
-- Do not touch package.path -- the lesson measured that those listed paths are not where
-- Neovim looked for your module. The NAME is wrong, and the mistake is in its first
-- component.
return {
  goal = 'Require the module at lua/d18ns/thing.lua by its correct name',
  hint = 'Where does the search start, and is that part of the name?',
  check = function()
    local dir = vim.fn.tempname()
    vim.fn.mkdir(dir .. '/lua/d18ns', 'p')
    vim.fn.writefile({ 'return { ok = true }' }, dir .. '/lua/d18ns/thing.lua')
    vim.opt.runtimepath:prepend(dir)

    local name = 'lua.d18ns.thing'

    package.loaded[name] = nil
    local ok, mod = pcall(require, name)
    assert(ok, ('require(%q) failed'):format(name))
    assert(mod.ok == true, 'the module should have loaded')
  end,
}
