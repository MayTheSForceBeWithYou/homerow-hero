-- Drill 10. And the catch that makes a restart authoritative. A reload produces a
-- DIFFERENT table, so anything holding the old one keeps the old functions.
--
-- Return true if the table after a reload differs from the one before it.
return {
  goal = 'Return whether a reloaded module is a different table from the original',
  check = function()
    local dir = vim.fn.tempname()
    vim.fn.mkdir(dir .. '/lua', 'p')
    vim.fn.writefile({ 'return {}' }, dir .. '/lua/d10mod.lua')
    vim.opt.runtimepath:prepend(dir)
    package.loaded['d10mod'] = nil

    local before = require('d10mod')
    package.loaded['d10mod'] = nil
    local after = require('d10mod')

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == true, 'a reload builds a new table, which is why captured references go stale')
  end,
}
