-- Drill 10. The working pattern, in three steps. The third is the one people omit.
return {
  goal = 'Change a field of a table stored in vim.g so the change persists',
  hint = 'Read it into a local, change that, then put it back.',
  check = function()
    vim.g.hero_d10 = { a = 1, list = { 1, 2 } }

    -- TODO_GUARD

    local cfg = vim.g.hero_d10 -- <- your answer
    cfg.a = 42 -- <- your answer
    vim.g.hero_d10 = cfg -- <- your answer

    assert(vim.g.hero_d10.a == 42, ('expected 42, got %s'):format(tostring(vim.g.hero_d10.a)))
    assert(#vim.g.hero_d10.list == 2, 'the rest of the table should survive')
    vim.g.hero_d10 = nil
  end,
}
