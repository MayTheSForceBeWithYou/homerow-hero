-- Drill 07. Each CALL to the maker creates a fresh local, so two counters are
-- independent. Return a list: { first_counter_after_three_calls, second_counter_first_call }.
return {
  goal = 'Return one counter after three calls and a second counter after one',
  check = function()
    local function counter()
      local n = 0
      return function()
        n = n + 1
        return n
      end
    end
    local c1, c2 = counter(), counter()

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer[1] == 3, ('the first counter should reach 3, got %s'):format(tostring(answer[1])))
    assert(answer[2] == 1, ('the second starts fresh at 1, got %s'):format(tostring(answer[2])))
  end,
}
