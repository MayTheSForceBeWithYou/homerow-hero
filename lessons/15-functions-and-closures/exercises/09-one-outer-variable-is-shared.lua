-- Drill 09. The contrast, and the bug behind "every callback behaves like the last one".
-- Here the captured variable is declared OUTSIDE the loop, so all three closures share it.
--
-- Predict the result before you run it, then return it as a list.
return {
  goal = 'Return the values of three closures all capturing one outer variable',
  hint = 'How many variables are there to capture?',
  check = function()
    local fns, j = {}, 0
    while j < 3 do
      j = j + 1
      fns[j] = function()
        return j
      end
    end

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(
      table.concat(answer, ',') == '3,3,3',
      ('one shared variable, so 3,3,3 -- got %s'):format(table.concat(answer, ','))
    )
  end,
}
