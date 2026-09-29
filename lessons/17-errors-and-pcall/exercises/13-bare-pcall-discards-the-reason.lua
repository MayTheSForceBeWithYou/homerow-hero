-- Drill 13. The mistake. `if not pcall(f) then` tells you that it failed and nothing about
-- why -- because the second return value is simply never bound to anything.
--
-- Return a list: { how_many_values_pcall_returns, the_captured_message }.
return {
  goal = 'Return how many values pcall gives back, and the message the bare form drops',
  hint = "select('#', ...) counts return values.",
  check = function()
    local function bad()
      error('the real reason')
    end

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(
      answer[1] == 2,
      ('pcall returns two values here, you said %s'):format(tostring(answer[1]))
    )
    assert(
      tostring(answer[2]):find('the real reason', 1, true),
      ('the second value is the message; got %s'):format(tostring(answer[2]))
    )
    -- So `if not pcall(bad) then` is not missing information that pcall failed to
    -- provide -- it is discarding information pcall handed over.
  end,
}
