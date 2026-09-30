-- Drill 12. And the truncation. The SAME call, not in the last position, is adjusted to
-- one value -- silently.
--
-- Return the table that `{ multi(), 9 }` produces. Predict it first.
return {
  goal = 'Return what a table constructor gives when a multi-value call is not last',
  hint = 'Count the elements before you run it.',
  check = function()
    local function multi()
      return 1, 2, 3
    end

    -- ANSWER_BEGIN
    local answer = { multi(), 9 }
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(#answer == 2, ('adjusted to one value plus the 9, so 2 -- got %d'):format(#answer))
    assert(
      table.concat(answer, ',') == '1,9',
      ('expected 1,9 -- got %s'):format(table.concat(answer, ','))
    )
  end,
}
