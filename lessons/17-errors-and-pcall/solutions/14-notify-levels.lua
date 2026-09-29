-- Drill 14. A guard that says nothing cannot be told from a guard that never fired. Return
-- the numeric level you would pass vim.notify for an EXPECTED, uninteresting skip.
return {
  goal = 'Return the log level for an expected, uninteresting event',
  hint = 'vim.log.levels has six names; you want the quiet one above TRACE.',
  check = function()
    -- ANSWER_BEGIN
    local answer = vim.log.levels.DEBUG
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == vim.log.levels.DEBUG, ('expected DEBUG, got %s'):format(tostring(answer)))
    assert(answer < vim.log.levels.WARN, 'and it should be quieter than WARN')
  end,
}
