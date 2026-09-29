-- Drill 18. Return a list of two booleans: whether a dense list is a list, and whether a
-- map is.
return {
  goal = 'Return whether a dense list and a map each count as a list',
  hint = 'One vim function answers both.',
  check = function()
    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer[1] == true, 'a dense integer-keyed table is a list')
    assert(answer[2] == false, 'a string-keyed table is not')
  end,
}
