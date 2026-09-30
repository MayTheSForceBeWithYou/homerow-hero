return {
  goal = 'Make the module usable by its caller',
  hint = 'What does require cache for a file that returns nothing?',
  check = function()
    local dir = vim.fn.tempname()
    vim.fn.mkdir(dir .. '/lua', 'p')
    vim.opt.runtimepath:prepend(dir)
    package.loaded['d17mod'] = nil

    -- A module that returns nothing is recorded in package.loaded as `true`, so require
    -- succeeds and the caller gets a boolean. One line fixes it, and its absence is the
    -- commonest mistake when writing a first module.
    local source = [[
      local M = {}
      function M.greet(name)
        return 'hello ' .. name
      end
      return M
    ]]

    vim.fn.writefile(vim.split(source, '\n'), dir .. '/lua/d17mod.lua')

    local mod = require('d17mod')
    assert(type(mod) == 'table', ('require gave a %s, not a table'):format(type(mod)))
    assert(mod.greet('world') == 'hello world', ('got %q'):format(tostring(mod.greet('world'))))
  end,
}
