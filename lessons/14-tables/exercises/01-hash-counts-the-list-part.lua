-- Drill 01. A table has a list part and a map part. `#` measures only the list part.
-- Return #t for the table below -- work it out before you run it.
return {
  goal = 'Return the length operator applied to a mixed table',
  hint = 'Which keys form a consecutive run from 1?',
  check = function()
    local t = { 'a', 'b', name = 'x', [9] = 'y' }

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(
      answer == 2,
      ('expected 2 -- only the run from 1 counts -- got %s'):format(tostring(answer))
    )
  end,
}
