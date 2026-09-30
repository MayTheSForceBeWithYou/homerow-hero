-- Drill 11. `print` stringifies a table as an address; one vim function renders its
-- contents. Return the rendered form of a small list.
return {
  goal = 'Return the rendered string form of the list { 1, 2, 3 }',
  hint = 'A vim function, not a Lua one.',
  check = function()
    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == '{ 1, 2, 3 }', ('expected "{ 1, 2, 3 }", got %q'):format(tostring(answer)))
    -- And note that plain tostring gives an address instead.
    assert(tostring({ 1, 2, 3 }):find('table: '), 'sanity: tostring gives an address')
  end,
}
