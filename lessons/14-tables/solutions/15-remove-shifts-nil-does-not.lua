-- Drill 15. Two ways to take an item out of a list, and only one keeps `#` meaningful.
-- Remove the middle item so the result is a dense three-element list.
return {
  goal = 'Remove the middle item of a four-element list without leaving a hole',
  hint = 'A table library function that shifts, rather than an assignment.',
  check = function()
    local t = { 'a', 'b', 'c', 'd' }

    -- TODO_GUARD

    table.remove(t, 2) -- <- your answer

    assert(#t == 3, ('expected a dense list of 3, got #t = %d'):format(#t))
    assert(table.concat(t, '') == 'acd', ('expected "acd", got %q'):format(table.concat(t, '')))
    -- And confirm ipairs can still see all of it, which a hole would have broken.
    local seen = 0
    for _ in ipairs(t) do
      seen = seen + 1
    end
    assert(seen == 3, 'ipairs should reach every element of a dense list')
  end,
}
