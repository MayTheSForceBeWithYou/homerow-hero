-- Drill 08. The cache has a name and you can look inside it. Return the table that holds
-- loaded modules, keyed by module name -- return the table itself, not a copy.
return {
  goal = 'Return the table require uses as its cache',
  hint = 'It lives on the package table.',
  check = function()
    local dir = vim.fn.tempname()
    vim.fn.mkdir(dir .. '/lua', 'p')
    vim.fn.writefile({ 'return { ok = true }' }, dir .. '/lua/d08mod.lua')
    vim.opt.runtimepath:prepend(dir)
    package.loaded['d08mod'] = nil
    require('d08mod')

    -- ANSWER_BEGIN
    local answer = package.loaded
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == package.loaded, 'return the cache table itself')
    assert(answer['d08mod'] ~= nil, 'the module you just required should be in it')
  end,
}
