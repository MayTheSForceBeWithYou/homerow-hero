-- Drill 08. The trap itself. Mutate a field through vim.g and return the stored value
-- afterwards -- which is unchanged, with no error raised.
--
-- Predict this before running it.
return {
  goal = 'Return the stored value after attempting to mutate a field through vim.g',
  check = function()
    vim.g.hero_d08 = { a = 1 }

    vim.g.hero_d08.a = 42

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == 1, ('the assignment is lost, so still 1; got %s'):format(tostring(answer)))
    vim.g.hero_d08 = nil
  end,
}
