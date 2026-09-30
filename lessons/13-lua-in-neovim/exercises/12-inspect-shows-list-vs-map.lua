-- Drill 12. A useful side effect: vim.inspect formats a LIST on one line and a MAP
-- across several, so the shape tells you which half of a table you have (lesson 14).
--
-- Return true if the list form contains no newline and the map form does.
return {
  goal = 'Return whether inspect renders a list on one line and a map on several',
  check = function()
    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == true, 'a list renders inline, a map renders across lines')
  end,
}
