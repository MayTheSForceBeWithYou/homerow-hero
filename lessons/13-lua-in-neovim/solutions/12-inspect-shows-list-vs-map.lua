-- Drill 12. A useful side effect: vim.inspect formats a LIST on one line and a MAP
-- across several, so the shape tells you which half of a table you have (lesson 14).
--
-- Return true if the list form contains no newline and the map form does.
return {
  goal = 'Return whether inspect renders a list on one line and a map on several',
  check = function()
    -- ANSWER_BEGIN
    local list_form = vim.inspect({ 1, 2, 3 })
    local map_form = vim.inspect({ a = 1, b = 2 })
    local answer = not list_form:find('\n') and map_form:find('\n') ~= nil
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == true, 'a list renders inline, a map renders across lines')
  end,
}
