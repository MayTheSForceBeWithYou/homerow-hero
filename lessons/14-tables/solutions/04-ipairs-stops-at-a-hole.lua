-- Drill 04. `ipairs` walks consecutive integer keys and stops at the first nil. Count how
-- many entries it visits in a list with a hole at position 3.
--
-- If a loop in your config is quietly doing less work than you expected, this is why.
return {
  goal = 'Return how many entries ipairs visits in { 1, 2, nil, 4, 5 }',
  check = function()
    local t = { 1, 2, nil, 4, 5 }

    -- ANSWER_BEGIN
    local seen = 0
    for _ in ipairs(t) do
      seen = seen + 1
    end
    local answer = seen
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == 2, ('ipairs stops at the hole, so 2; got %s'):format(tostring(answer)))
  end,
}
