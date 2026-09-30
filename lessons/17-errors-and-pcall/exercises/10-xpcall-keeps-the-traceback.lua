-- Drill 10. And the recovery. A handler passed to xpcall runs while the stack still
-- exists, so it can capture it.
--
-- Return the error value from a protected call that keeps the traceback.
return {
  goal = 'Protect a failing call in a way that captures the stack traceback',
  hint = 'One function, and one standard handler from the debug library.',
  check = function()
    local function inner()
      error('deep')
    end
    local function outer()
      inner()
    end

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(
      tostring(answer):find('stack traceback', 1, true),
      ('expected a traceback, got %q'):format(tostring(answer))
    )
    assert(tostring(answer):find('deep', 1, true), 'and the original message')
  end,
}
