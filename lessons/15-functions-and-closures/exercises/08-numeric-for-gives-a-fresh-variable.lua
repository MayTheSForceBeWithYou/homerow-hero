-- Drill 08. A numeric `for` creates a NEW variable each iteration, so three closures made
-- inside it captured three different variables.
--
-- Return what the three closures produce, as a list.
return {
  goal = 'Return the values of three closures each capturing a numeric for variable',
  check = function()
    local fns = {}
    for i = 1, 3 do
      fns[i] = function()
        return i
      end
    end

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(
      table.concat(answer, ',') == '1,2,3',
      ('each iteration has its own variable, so 1,2,3 -- got %s'):format(table.concat(answer, ','))
    )
  end,
}
