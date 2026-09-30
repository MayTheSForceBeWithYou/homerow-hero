-- Drill 13. `+` on an Option means APPEND, not add -- and the result is an Option, not a
-- number, so the failure surfaces wherever the value is finally used.
--
-- Return a list: { type_of_the_result, whether_formatting_it_as_a_number_raises }.
return {
  goal = 'Return the type of vim.opt.shiftwidth + 1, and whether formatting it raises',
  check = function()
    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer[1] == 'table', 'the result is still an Option object')
    assert(answer[2] == true, 'formatting an Option as a number raises')
  end,
}
