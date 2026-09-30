-- Drill 06. A non-string error passes through unchanged, which is how you hand structured
-- information to a caller that will inspect it.
--
-- Raise a table with a `code` field and return the code the catcher sees.
return {
  goal = 'Raise a table error and return the field the catcher reads from it',
  check = function()
    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == 42, ('expected 42, got %s'):format(tostring(answer)))
  end,
}
