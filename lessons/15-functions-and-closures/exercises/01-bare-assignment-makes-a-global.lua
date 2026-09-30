-- Drill 01. A bare assignment creates a global, with no declaration and no warning.
-- Call the leaky function, then return the value now visible in the global table.
return {
  goal = 'Return the value a missing `local` left in the global table',
  hint = 'The global table has a name.',
  check = function()
    _G.hero_oops = nil
    local function leaky()
      hero_oops = 42
    end
    leaky()

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == 42, ('expected 42, got %s'):format(tostring(answer)))
    _G.hero_oops = nil
  end,
}
