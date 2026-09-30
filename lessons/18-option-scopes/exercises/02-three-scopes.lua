-- Drill 02. Return the scopes of three options as a list, in this order:
-- 'number', 'hlsearch', 'expandtab'.
return {
  goal = 'Return the scopes of number, hlsearch and expandtab in that order',
  check = function()
    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer[1] == 'win', 'number is window-scoped')
    assert(answer[2] == 'global', 'hlsearch is global')
    assert(answer[3] == 'buf', 'expandtab is buffer-scoped')
  end,
}
