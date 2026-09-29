-- Drill 11. The uncached alternative. Run the same file twice with the function that does
-- NOT cache, and return how many times it ran.
return {
  goal = 'Run a file twice without caching, and return the run count',
  hint = 'One word, and it is not require.',
  check = function()
    local dir = vim.fn.tempname()
    vim.fn.mkdir(dir, 'p')
    local path = dir .. '/plain.lua'
    vim.fn.writefile({ '_G.hero_d11_runs = (_G.hero_d11_runs or 0) + 1', 'return {}' }, path)
    _G.hero_d11_runs = 0

    -- TODO_GUARD

    dofile(path) -- <- your answer
    dofile(path) -- <- your answer

    assert(_G.hero_d11_runs ~= nil, 'DRILL_TODO')
    assert(
      _G.hero_d11_runs == 2,
      ('an uncached loader runs it every time, so 2; got %s'):format(tostring(_G.hero_d11_runs))
    )
    _G.hero_d11_runs = nil
  end,
}
