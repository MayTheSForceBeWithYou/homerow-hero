-- Drill 20. BUG HUNT -- starts FAILING.
--
-- The intent is to drop the middle item from a four-element list, leaving a dense list of
-- three that `ipairs` can walk completely.
--
-- Run it: `#t` is wrong and the ipairs count is short. Assigning nil does not shift the
-- remaining elements -- it punches a hole, and a hole makes `#` unspecified and stops
-- ipairs dead.
return {
  goal = 'Remove the middle item of a four-element list without leaving a hole',
  hint = 'A table library function shifts the rest down. An assignment does not.',
  check = function()
    local t = { 'a', 'b', 'c', 'd' }

    t[2] = nil

    assert(#t == 3, ('expected a dense list of 3, got #t = %d'):format(#t))
    assert(table.concat(t, '') == 'acd', ('expected "acd", got %q'):format(table.concat(t, '')))
    local seen = 0
    for _ in ipairs(t) do
      seen = seen + 1
    end
    assert(seen == 3, ('ipairs reached only %d elements -- there is a hole'):format(seen))
  end,
}
