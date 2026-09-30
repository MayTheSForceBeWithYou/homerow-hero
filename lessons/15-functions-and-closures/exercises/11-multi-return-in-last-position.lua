-- Drill 11. A multi-value call keeps every value when it is the LAST item. Return a table
-- built from a three-value call in that position.
return {
  goal = 'Return a table containing all three values of a multi-value call',
  check = function()
    local function multi()
      return 1, 2, 3
    end

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(#answer == 3, ('expected three values, got %d'):format(#answer))
    assert(table.concat(answer, ',') == '1,2,3', 'expected 1,2,3')
  end,
}
