-- Drill 12. The vocabulary of option merging. Return a list of the two merged tables:
-- first with the later argument winning, then with the earlier one winning.
return {
  goal = 'Merge the same two tables both ways and return both results',
  hint = 'The first argument to vim.tbl_extend names the behaviour.',
  check = function()
    local defaults = { a = 1, b = 1 }
    local user = { b = 2 }

    -- ANSWER_BEGIN
    local answer = {
      vim.tbl_extend('force', defaults, user),
      vim.tbl_extend('keep', defaults, user),
    }
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer[1].b == 2, "'force' should let the later table win")
    assert(answer[2].b == 1, "'keep' should let the earlier table win")
    assert(answer[1].a == 1 and answer[2].a == 1, 'untouched keys survive either way')
  end,
}
