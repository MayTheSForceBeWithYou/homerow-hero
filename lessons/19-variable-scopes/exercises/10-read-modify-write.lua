-- Drill 10. The working pattern, in three steps. The third is the one people omit.
return {
  goal = 'Change a field of a table stored in vim.g so the change persists',
  hint = 'Read it into a local, change that, then put it back.',
  check = function()
    vim.g.hero_d10 = { a = 1, list = { 1, 2 } }

    error('DRILL_TODO') -- delete this line once you have written your answer

    -- <- your answer: write this line
    -- <- your answer: write this line
    -- <- your answer: write this line

    assert(vim.g.hero_d10.a == 42, ('expected 42, got %s'):format(tostring(vim.g.hero_d10.a)))
    assert(#vim.g.hero_d10.list == 2, 'the rest of the table should survive')
    vim.g.hero_d10 = nil
  end,
}
