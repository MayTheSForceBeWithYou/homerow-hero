-- Drill 08. With no integer type, a division that comes out whole is indistinguishable
-- from a whole number. Return what tostring() gives for 10/2 -- as a string.
--
-- In Lua 5.3+ this would be "5.0".
return {
  goal = 'Return the string form of 10/2 as this Lua renders it',
  check = function()
    -- ANSWER_BEGIN
    local answer = tostring(10 / 2)
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == '5', ('5.1 renders it as "5"; you said %q'):format(tostring(answer)))
  end,
}
