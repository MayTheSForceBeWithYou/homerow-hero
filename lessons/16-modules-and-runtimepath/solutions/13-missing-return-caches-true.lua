-- Drill 13. A module that forgets `return M` is recorded as loaded with the value `true`.
-- Return what require gives for such a module.
--
-- The symptom in real code is "attempt to index a boolean value", which by lesson 13's
-- rule is NOT a name problem -- the name resolved fine, to a boolean.
return {
  goal = 'Return what require yields for a module with no return statement',
  check = function()
    local dir = vim.fn.tempname()
    vim.fn.mkdir(dir .. '/lua', 'p')
    vim.fn.writefile(
      { 'local M = {}', 'function M.f() end', '-- no return' },
      dir .. '/lua/d13mod.lua'
    )
    vim.opt.runtimepath:prepend(dir)
    package.loaded['d13mod'] = nil

    -- ANSWER_BEGIN
    local answer = require('d13mod')
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == true, ('expected the boolean true, got %s'):format(vim.inspect(answer)))
  end,
}
