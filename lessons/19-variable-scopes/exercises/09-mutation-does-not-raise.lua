-- Drill 09. And the part that makes it expensive: it does not raise. Return whether the
-- lost assignment produced an error.
return {
  goal = 'Return whether mutating a field through vim.g raises an error',
  check = function()
    vim.g.hero_d09 = { a = 1 }

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == false, 'every individual step was legal, so nothing raises')
    vim.g.hero_d09 = nil
  end,
}
