-- Drill 14. And the fix: merge deeply, so the override touches one field and the siblings
-- survive. Return the merged keys table.
return {
  goal = 'Deep-merge the override so both close and accept survive',
  hint = 'A different vim.tbl_ function, same first argument.',
  check = function()
    local defaults = { keys = { close = 'q', accept = '<CR>' } }

    -- ANSWER_BEGIN
    local answer = vim.tbl_deep_extend('force', defaults, { keys = { close = 'x' } })
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer.keys.close == 'x', 'the override should have won')
    assert(answer.keys.accept == '<CR>', 'the sibling should have survived')
  end,
}
