-- Drill 01. A module is a file that RETURNS something. Build one that returns a table
-- with a `greet` function, then return what require() hands back.
--
-- `setup` creates a fixture directory and puts it on the runtimepath; you write the
-- module's contents.
return {
  goal = 'Write a module returning a table with a greet function, and require it',
  hint = 'A local table, functions on it, and one return at the end.',
  check = function()
    local dir = vim.fn.tempname()
    vim.fn.mkdir(dir .. '/lua', 'p')
    vim.opt.runtimepath:prepend(dir)
    package.loaded['d01mod'] = nil

    local answer = nil -- <- your answer

    assert(source ~= nil, 'DRILL_TODO')
    vim.fn.writefile(vim.split(source, '\n'), dir .. '/lua/d01mod.lua')

    local mod = require('d01mod')
    assert(type(mod) == 'table', ('require gave a %s, not a table'):format(type(mod)))
    assert(type(mod.greet) == 'function', 'the module should expose a greet function')
    assert(mod.greet('world') == 'hello world', ('got %q'):format(tostring(mod.greet('world'))))
  end,
}
