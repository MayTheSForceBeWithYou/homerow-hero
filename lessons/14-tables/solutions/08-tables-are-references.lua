-- Drill 08. Assignment copies a reference, not the table. Return the value of a[1] after
-- mutating through the second name.
return {
  goal = 'Return a[1] after assigning b = a and writing b[1] = 99',
  check = function()
    local a = { 1, 2 }
    local b = a
    b[1] = 99

    -- ANSWER_BEGIN
    local answer = a[1]
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == 99, ('they are the same table, so 99; got %s'):format(tostring(answer)))
  end,
}
