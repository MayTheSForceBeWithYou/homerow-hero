-- Drill 14. Using `...` in a function that was not declared with it is a PARSE error, not
-- a runtime one -- so like lesson 13's `//`, no pcall can reach it.
--
-- Return true if the chunk fails to compile.
return {
  goal = 'Return whether `...` in a non-vararg function fails to compile',
  check = function()
    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == true, 'this is a compile error, not a runtime one')
    local _, err = load('local function f() return ... end')
    assert(
      tostring(err):find('vararg', 1, true),
      ('expected a vararg message, got %q'):format(tostring(err))
    )
  end,
}
