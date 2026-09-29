-- Drill 12. Two runtimepath entries both providing lua/shared.lua. Return which one wins.
return {
  goal = 'Return which runtimepath entry provides the module when two both define it',
  hint = 'It is a search path in the ordinary sense.',
  check = function()
    local d1, d2 = vim.fn.tempname(), vim.fn.tempname()
    vim.fn.mkdir(d1 .. '/lua', 'p')
    vim.fn.mkdir(d2 .. '/lua', 'p')
    vim.fn.writefile({ "return { from = 'first' }" }, d1 .. '/lua/d12shared.lua')
    vim.fn.writefile({ "return { from = 'second' }" }, d2 .. '/lua/d12shared.lua')
    package.loaded['d12shared'] = nil
    vim.opt.runtimepath:prepend(d2)
    vim.opt.runtimepath:prepend(d1) -- d1 is now the earlier entry

    -- ANSWER_BEGIN
    local answer = require('d12shared').from
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == 'first', ('the earlier entry should win, got %q'):format(tostring(answer)))
  end,
}
