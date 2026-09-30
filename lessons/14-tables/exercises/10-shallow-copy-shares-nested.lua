-- Drill 10. A shallow copy gives you a new top-level table whose VALUES are the same
-- references. Mutate the nested table through the copy and return the original's value.
--
-- This is the surprise that makes deepcopy necessary rather than merely cautious.
return {
  goal = "Return the original's nested value after mutating it through a shallow copy",
  check = function()
    local orig = { nested = { x = 1 } }
    local shallow = vim.tbl_extend('force', {}, orig)
    shallow.nested.x = 99

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == 99, ('the nested table is shared, so 99; got %s'):format(tostring(answer)))
  end,
}
