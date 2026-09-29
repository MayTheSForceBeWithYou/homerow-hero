-- Drill 17. Two list helpers worth knowing so you do not reimplement them. Return a list:
-- { appended, sliced } where appended is {1,2,3} built by extending {1} with {2,3}, and
-- sliced is elements 2 through 3 of {1,2,3,4}.
return {
  goal = 'Return an extended list and a sliced list',
  check = function()
    -- ANSWER_BEGIN
    local answer = {
      vim.list_extend({ 1 }, { 2, 3 }),
      vim.list_slice({ 1, 2, 3, 4 }, 2, 3),
    }
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(table.concat(answer[1], ',') == '1,2,3', ('got %s'):format(table.concat(answer[1], ',')))
    assert(table.concat(answer[2], ',') == '2,3', ('got %s'):format(table.concat(answer[2], ',')))
  end,
}
