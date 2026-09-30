-- Drill 02. And on failure the second value is the error, complete with the position that
-- `error` prepended. Return true if the captured message mentions the word raised.
return {
  goal = 'Protect a failing call and confirm the error text is captured',
  hint = 'Keep BOTH return values.',
  check = function()
    local function bad()
      error('the real reason')
    end

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer[1] == false, 'a failing call gives false')
    assert(
      tostring(answer[2]):find('the real reason', 1, true),
      ('the error text should have been captured, got %s'):format(tostring(answer[2]))
    )
  end,
}
