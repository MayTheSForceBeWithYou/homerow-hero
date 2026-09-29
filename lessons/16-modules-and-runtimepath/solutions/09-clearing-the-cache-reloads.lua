-- Drill 09. Forcing a reload. Clear the cache entry, require again, and return how many
-- times the file has now run.
return {
  goal = 'Reload a module by clearing its cache entry, and return the run count',
  hint = 'Assign nil to its key in the cache.',
  check = function()
    local dir = vim.fn.tempname()
    vim.fn.mkdir(dir .. '/lua', 'p')
    vim.fn.writefile({
      '_G.hero_d09_runs = (_G.hero_d09_runs or 0) + 1',
      'return {}',
    }, dir .. '/lua/d09mod.lua')
    vim.opt.runtimepath:prepend(dir)
    package.loaded['d09mod'] = nil
    _G.hero_d09_runs = 0
    require('d09mod')

    -- TODO_GUARD

    package.loaded['d09mod'] = nil -- <- your answer

    require('d09mod')
    assert(
      _G.hero_d09_runs == 2,
      ('the file should have run twice, ran %s'):format(tostring(_G.hero_d09_runs))
    )
    _G.hero_d09_runs = nil
  end,
}
