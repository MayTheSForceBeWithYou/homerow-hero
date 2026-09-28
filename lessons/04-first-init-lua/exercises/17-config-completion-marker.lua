-- Drill 17. Carried forward from lesson 00, because it is the habit that makes
-- every later lesson debuggable. Simulate a config that fails part way down, then
-- confirm the completion marker is absent while the early marker is present.
return {
  goal = 'Confirm that only a marker on the last line proves a config ran to completion',
  check = function()
    vim.g.hero_drill_started = nil
    vim.g.hero_drill_finished = nil

    pcall(function()
      vim.g.hero_drill_started = true
      vim.opt.nosuchoption = 1 -- a real error, exactly as a typo in a config would be
      vim.g.hero_drill_finished = true
    end)

    local answer = nil -- <- your answer
    assert(answer ~= nil, 'DRILL_TODO')
    assert(vim.g.hero_drill_started == true, 'the early marker should have been set')
    assert(
      vim.g[answer] == nil,
      ('%s should be unset -- the file raised before reaching it'):format(answer)
    )
    assert(answer == 'hero_drill_finished', 'name the marker that proves completion')
  end,
}
