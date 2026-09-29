-- Drill 07. The idiom for code that must work on both. Write a local that resolves to
-- whichever spelling exists, then use it.
return {
  goal = 'Bind a portable unpack and use it to return the three values from a list',
  hint = 'One expression with `or` covers both spellings.',
  check = function()
    -- ANSWER_BEGIN
    local unpack_fn = table.unpack or unpack
    local answer = { unpack_fn({ 10, 20, 30 }) }
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(#answer == 3, ('expected three values, got %d'):format(#answer))
    assert(answer[1] == 10 and answer[3] == 30, 'expected 10, 20, 30')
  end,
}
