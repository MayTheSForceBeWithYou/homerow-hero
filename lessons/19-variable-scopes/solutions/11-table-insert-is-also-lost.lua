-- Drill 11. The same cause with a different surface. Return the length of a stored list
-- after appending to it through vim.g.
return {
  goal = 'Return the stored list length after table.insert through vim.g',
  check = function()
    vim.g.hero_d11 = { 1, 2 }

    table.insert(vim.g.hero_d11, 3)

    -- ANSWER_BEGIN
    local answer = #vim.g.hero_d11
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(
      answer == 2,
      ('the insert went to a temporary, so still 2; got %s'):format(tostring(answer))
    )
    vim.g.hero_d11 = nil
  end,
}
