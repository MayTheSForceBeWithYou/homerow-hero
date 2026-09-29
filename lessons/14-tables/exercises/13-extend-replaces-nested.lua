-- Drill 13. The shallow merge REPLACES a nested table rather than merging it, so a caller
-- overriding one field loses its siblings.
--
-- Return whether the sibling key survived a shallow merge.
return {
  goal = 'Return whether a sibling key survives a shallow merge of a nested table',
  check = function()
    local defaults = { keys = { close = 'q', accept = '<CR>' } }
    local merged = vim.tbl_extend('force', defaults, { keys = { close = 'x' } })

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == false, 'a shallow merge replaces the whole nested table, losing accept')
  end,
}
