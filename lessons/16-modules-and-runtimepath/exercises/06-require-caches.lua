-- Drill 06. `require` runs a file once per session. Require the same module twice and
-- return how many times its top-level code ran.
return {
  goal = 'Return how many times a module file runs when required twice',
  check = function()
    local dir = vim.fn.tempname()
    vim.fn.mkdir(dir .. '/lua', 'p')
    vim.fn.writefile({
      '_G.hero_d06_runs = (_G.hero_d06_runs or 0) + 1',
      'return { n = _G.hero_d06_runs }',
    }, dir .. '/lua/d06mod.lua')
    vim.opt.runtimepath:prepend(dir)
    package.loaded['d06mod'] = nil
    _G.hero_d06_runs = 0

    require('d06mod')
    require('d06mod')

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == 1, ('require caches, so 1; got %s'):format(tostring(answer)))
    _G.hero_d06_runs = nil
  end,
}
