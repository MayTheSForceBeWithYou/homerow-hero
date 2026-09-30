-- Drill 11. And the fix. Copy deeply, mutate the copy, and confirm the original is
-- untouched.
return {
  goal = "Copy a nested table independently, then return the original's value after mutating the copy",
  hint = 'One vim function.',
  check = function()
    local orig = { nested = { x = 1 } }

    local answer = nil -- <- your answer

    assert(copy ~= nil, 'DRILL_TODO')
    copy.nested.x = 77
    assert(
      orig.nested.x == 1,
      ('the original should be untouched, is %s'):format(tostring(orig.nested.x))
    )
    assert(copy.nested.x == 77, 'the copy should have changed')
  end,
}
