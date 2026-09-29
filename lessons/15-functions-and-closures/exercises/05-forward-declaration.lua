-- Drill 05. The fix, and what makes mutual recursion possible. Declare the name first,
-- define the function that uses it, then fill the name in.
--
-- Complete the chunk so it returns 1.
return {
  goal = 'Make a function that calls a later-defined local work, using a forward declaration',
  hint = 'One bare `local` line, before the function that captures it.',
  check = function()
    local answer = nil -- <- your answer

    assert(a ~= nil, 'DRILL_TODO')
    assert(a() == 1, ('expected 1, got %s'):format(tostring(a())))
  end,
}
