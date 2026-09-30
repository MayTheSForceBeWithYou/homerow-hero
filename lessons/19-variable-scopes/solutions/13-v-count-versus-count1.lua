-- Drill 13. The pair that matters for mappings. With no count typed, one is 0 and the other
-- is 1. Return them as a list: { count, count1 }.
return {
  goal = 'Return v:count and v:count1 when no count has been typed',
  check = function()
    -- ANSWER_BEGIN
    local answer = { vim.v.count, vim.v.count1 }
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer[1] == 0, ('v:count is 0 with no count, got %s'):format(tostring(answer[1])))
    assert(answer[2] == 1, ('v:count1 is 1 with no count, got %s'):format(tostring(answer[2])))
  end,
}
