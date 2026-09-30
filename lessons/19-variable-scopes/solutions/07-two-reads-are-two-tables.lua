-- Drill 07. The cause of this lesson's worst trap, in one line. Return true if two reads of
-- the same stored table give DIFFERENT Lua tables.
return {
  goal = 'Return whether two reads of a table in vim.g give different tables',
  hint = 'Lesson 14: == on tables is identity.',
  check = function()
    vim.g.hero_d07 = { a = 1 }

    -- ANSWER_BEGIN
    local first, second = vim.g.hero_d07, vim.g.hero_d07
    local answer = first ~= second
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == true, 'each read constructs a fresh Lua table from the stored value')
    vim.g.hero_d07 = nil
  end,
}
