-- Drill 08. The trap from lesson 00, in a new place. Only nil and false are falsy in Lua,
-- so a zero passes an assert.
--
-- Return whether assert(0) raises.
return {
  goal = 'Return whether assert(0) raises',
  check = function()
    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == false, '0 is truthy in Lua, so the assert passes and nothing raises')
  end,
}
