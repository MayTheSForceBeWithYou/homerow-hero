-- Drill 06. A function that references an enclosing local keeps it alive -- private state
-- with no table and no globals. Build a counter and return its first three results.
return {
  goal = 'Build a counter closure and return its first three values as a list',
  hint = 'A local inside the maker, and a function returned that increments it.',
  check = function()
    -- ANSWER_BEGIN
    local function counter()
      local n = 0
      return function()
        n = n + 1
        return n
      end
    end
    -- ANSWER_END

    assert(counter ~= nil, 'DRILL_TODO')
    local c = counter()
    local got = { c(), c(), c() }
    assert(
      table.concat(got, ',') == '1,2,3',
      ('expected 1,2,3 -- got %s'):format(table.concat(got, ','))
    )
  end,
}
