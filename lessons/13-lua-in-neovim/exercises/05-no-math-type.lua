-- Drill 05. There is no integer/float distinction in 5.1, so the function that reports
-- which one you have does not exist. Return true if it is absent.
return {
  goal = 'Return whether math.type is absent',
  check = function()
    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == true, 'math.type arrived in 5.3 and is not here')
  end,
}
