-- Drill 20. BUG HUNT -- starts FAILING.
--
-- The intent is to collect all three values a function returns, plus a trailing marker.
-- Run it: the table has two elements and the 2 and 3 are gone, with no warning.
--
-- The call is fine and the function is fine. Its POSITION is the problem.
return {
  goal = 'Collect all three returned values along with a trailing marker',
  hint = 'A multi-value call keeps every value in exactly one position.',
  check = function()
    local function multi()
      return 1, 2, 3
    end

    local answer = { multi(), 'end' }

    assert(#answer == 4, ('expected four elements, got %d'):format(#answer))
    assert(
      table.concat(answer, ',') == '1,2,3,end',
      ('expected 1,2,3,end -- got %s'):format(table.concat(answer, ','))
    )
  end,
}
