return {
  goal = 'Require the module at lua/d18ns/thing.lua by its correct name',
  hint = 'Where does the search start, and is that part of the name?',
  check = function()
    local dir = vim.fn.tempname()
    vim.fn.mkdir(dir .. '/lua/d18ns', 'p')
    vim.fn.writefile({ 'return { ok = true }' }, dir .. '/lua/d18ns/thing.lua')
    vim.opt.runtimepath:prepend(dir)

    -- The `lua/` directory is where the search BEGINS, so it never appears in the module
    -- name. Dots are path separators below that point, and nothing else.
    local name = 'd18ns.thing'

    package.loaded[name] = nil
    local ok, mod = pcall(require, name)
    assert(ok, ('require(%q) failed'):format(name))
    assert(mod.ok == true, 'the module should have loaded')
  end,
}
