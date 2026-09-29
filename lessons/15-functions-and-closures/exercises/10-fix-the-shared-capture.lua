-- Drill 10. Fix drill 09 without changing the loop to a numeric `for`: introduce a new
-- local inside the loop body so each closure captures its own.
return {
  goal = 'Make three closures in a while loop each return their own value',
  hint = 'One extra local, inside the body.',
  check = function()
    local fns, j = {}, 0
    while j < 3 do
      j = j + 1

      local answer = nil -- <- your answer
    end

    assert(fns[1] ~= nil, 'DRILL_TODO')
    local got = { fns[1](), fns[2](), fns[3]() }
    assert(
      table.concat(got, ',') == '1,2,3',
      ('expected 1,2,3 -- got %s'):format(table.concat(got, ','))
    )
  end,
}
