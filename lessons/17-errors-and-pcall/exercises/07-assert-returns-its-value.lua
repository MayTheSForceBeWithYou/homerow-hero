-- Drill 07. `assert` is error with a condition -- and it returns its value on success, so
-- it can check and bind in one step.
--
-- Return what assert gives back for a truthy value.
return {
  goal = 'Return the value assert hands back when its condition holds',
  check = function()
    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(
      answer == 42,
      ('assert returns its first argument, so 42; got %s'):format(tostring(answer))
    )
  end,
}
