-- Drill 05. The contrast. `pairs` visits every key regardless of holes. Count them in the
-- same table.
return {
  goal = 'Return how many entries pairs visits in { 1, 2, nil, 4, 5 }',
  check = function()
    local t = { 1, 2, nil, 4, 5 }

    -- ANSWER_BEGIN
    local seen = 0
    for _ in pairs(t) do
      seen = seen + 1
    end
    local answer = seen
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == 4, ('pairs finds all four surviving keys; got %s'):format(tostring(answer)))
  end,
}
