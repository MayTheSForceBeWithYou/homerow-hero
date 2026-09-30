-- Drill 07. The consequence: every require of a name hands back the SAME value, not an
-- equal copy. Return true if two requires give the identical table.
return {
  goal = 'Return whether two requires of one module give the same table',
  hint = 'Lesson 14: == on tables is identity.',
  check = function()
    local dir = vim.fn.tempname()
    vim.fn.mkdir(dir .. '/lua', 'p')
    vim.fn.writefile({ 'return {}' }, dir .. '/lua/d07mod.lua')
    vim.opt.runtimepath:prepend(dir)
    package.loaded['d07mod'] = nil

    -- ANSWER_BEGIN
    local answer = require('d07mod') == require('d07mod')
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == true, 'require returns the cached value, so it is the identical table')
  end,
}
