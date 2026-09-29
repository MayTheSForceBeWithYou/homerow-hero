-- Drill 02. For a table that is all map, `#` is 0 and useless. Return the number of keys
-- the table actually has, using the vim helper for it.
return {
  goal = 'Return the total number of keys in a map-only table',
  hint = 'A vim.tbl_ function, not the length operator.',
  check = function()
    local t = { alpha = 1, beta = 2, gamma = 3 }
    assert(#t == 0, 'sanity: the length operator sees nothing here')

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == 3, ('expected 3, got %s'):format(tostring(answer)))
  end,
}
