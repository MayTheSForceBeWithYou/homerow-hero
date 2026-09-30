-- Drill 09. `==` on tables compares identity, not contents. Return a list:
-- { same_reference_is_equal, equal_contents_are_equal }.
return {
  goal = 'Return whether two names for one table are equal, and whether two tables with equal contents are',
  check = function()
    local a = { 1 }
    local b = a

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer[1] == true, 'two names for one table are equal')
    assert(answer[2] == false, 'two distinct tables are never equal, however alike')
  end,
}
