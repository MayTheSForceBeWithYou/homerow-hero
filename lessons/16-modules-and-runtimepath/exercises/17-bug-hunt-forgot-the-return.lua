-- Drill 17. BUG HUNT -- starts FAILING.
--
-- The module is written, the file is on the runtimepath, and require() SUCCEEDS. Then
-- using it fails with "attempt to index a boolean value".
--
-- By lesson 13's rule that is not a name problem -- the name resolved fine. Read what it
-- resolved TO, and ask what a module that returns nothing is recorded as.
return {
  goal = 'Make the module usable by its caller',
  hint = 'What does require cache for a file that returns nothing?',
  check = function()
    local dir = vim.fn.tempname()
    vim.fn.mkdir(dir .. '/lua', 'p')
    vim.opt.runtimepath:prepend(dir)
    package.loaded['d17mod'] = nil

    local source = [[
      local M = {}
      function M.greet(name)
        return 'hello ' .. name
      end
    ]]

    vim.fn.writefile(vim.split(source, '\n'), dir .. '/lua/d17mod.lua')

    local mod = require('d17mod')
    assert(type(mod) == 'table', ('require gave a %s, not a table'):format(type(mod)))
    assert(mod.greet('world') == 'hello world', ('got %q'):format(tostring(mod.greet('world'))))
  end,
}
