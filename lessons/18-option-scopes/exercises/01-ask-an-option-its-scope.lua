-- Drill 01. Stop guessing which scope an option has -- ask. Return the scope string for
-- 'shiftwidth'.
return {
  goal = "Return the scope of the 'shiftwidth' option",
  hint = "One nvim_ function reports an option's own metadata.",
  check = function()
    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == 'buf', ('shiftwidth is buffer-scoped; you said %q'):format(tostring(answer)))
  end,
}
