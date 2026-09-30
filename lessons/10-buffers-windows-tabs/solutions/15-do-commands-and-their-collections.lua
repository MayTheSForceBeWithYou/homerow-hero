-- Drill 15. Four commands, four collections. Return a list matching each command to
-- what it iterates, in this order: argdo, bufdo, windo, tabdo.
--
-- Use exactly these strings: 'arglist', 'buffers', 'windows', 'tabpages'.
return {
  goal = 'Return what argdo, bufdo, windo and tabdo each iterate, in that order',
  run = function()
    return { 'arglist', 'buffers', 'windows', 'tabpages' } -- <- your answer
  end,
  value = { 'arglist', 'buffers', 'windows', 'tabpages' },
}
