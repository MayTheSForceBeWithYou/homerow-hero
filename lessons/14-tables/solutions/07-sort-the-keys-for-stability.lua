-- Drill 07. The fix. To iterate a map predictably, collect the keys, sort them, then walk
-- the sorted list. Return the sorted keys as a list.
return {
  goal = 'Return the keys of a map in sorted order',
  hint = 'One vim.tbl_ call and one table library call.',
  check = function()
    local t = { zebra = 1, apple = 2, mango = 3 }

    -- ANSWER_BEGIN
    local answer = vim.tbl_keys(t)
    table.sort(answer)
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(
      table.concat(answer, ' ') == 'apple mango zebra',
      ('expected "apple mango zebra", got %q'):format(table.concat(answer, ' '))
    )
  end,
}
