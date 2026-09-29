-- Drill 09. Protecting a call costs you the stack. Return whether the message pcall gives
-- back for a two-deep failure contains a traceback.
return {
  goal = 'Return whether a pcall error message contains a stack traceback',
  check = function()
    local function inner()
      error('deep')
    end
    local function outer()
      inner()
    end

    -- ANSWER_BEGIN
    local _, err = pcall(outer)
    local answer = tostring(err):find('stack traceback', 1, true) ~= nil
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == false, 'pcall discards the traceback -- you get one line')
  end,
}
