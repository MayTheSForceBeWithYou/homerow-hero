-- Drill 04. Write the division that works here. 7 divided by 2, rounded down.
return {
  goal = 'Return 7 divided by 2 rounded down, using a spelling that compiles here',
  hint = 'A function from the math library.',
  check = function()
    -- ANSWER_BEGIN
    local answer = math.floor(7 / 2)
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == 3, ('expected 3, got %s'):format(tostring(answer)))
  end,
}
