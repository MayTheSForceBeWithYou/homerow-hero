-- Drill 05. The level argument decides whose line is blamed. In a validation helper the
-- useful location is the CALLER's, not the helper's.
--
-- Return the level you pass to blame the caller.
return {
  goal = 'Return the error level that blames the caller rather than the erroring line',
  check = function()
    local answer = 2 -- <- your answer
    assert(answer ~= nil, 'DRILL_TODO')

    -- The helper raises at the level you chose; the check confirms the reported line is
    -- the caller's, not the helper's.
    local helper_line, caller_line
    local function helper()
      helper_line = debug.getinfo(1, 'l').currentline
      error('bad argument', answer)
    end
    local function caller()
      caller_line = debug.getinfo(1, 'l').currentline + 1
      helper()
    end
    local _, err = pcall(caller)
    assert(
      tostring(err):find(':' .. tostring(caller_line) .. ':', 1, true),
      ('expected the caller line %d to be blamed, got %q'):format(caller_line, tostring(err))
    )
    assert(helper_line ~= caller_line, 'sanity: the two lines differ')
  end,
}
