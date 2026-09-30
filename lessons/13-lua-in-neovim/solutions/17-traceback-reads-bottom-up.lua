-- Drill 17. A traceback's frames run from the failure at the top to the entry point at
-- the bottom. Return which end holds the failure, as the string 'top' or 'bottom'.
return {
  goal = 'Return which end of a traceback holds the failure',
  check = function()
    local answer = 'top' -- <- your answer
    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == 'top', 'the highest frame is where it broke; the lowest is where it started')

    -- Produce a real traceback so the shape is in front of you when you run this.
    local function inner()
      error('boom')
    end
    local function outer()
      inner()
    end
    local ok, err = xpcall(outer, debug.traceback)
    assert(not ok)
    local frames = select(2, tostring(err):gsub('\n', ''))
    assert(frames >= 3, 'the traceback should have several frames to read')
  end,
}
