-- Drill 07. The trick almost nobody knows: help completion accepts wildcards. You
-- remember there is a function under `vim.` whose name ends in `set`, but not which
-- module it lives in.
--
-- Return a completion pattern that finds it, and the check confirms
-- vim.keymap.set() is among the matches.
return {
  goal = 'Return a wildcard pattern that finds vim.*.set functions',
  hint = 'One asterisk, where the module name would go.',
  check = function()
    -- ANSWER_BEGIN
    local answer = 'vim.*.set'
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    local matches = vim.fn.getcompletion(answer, 'help')
    assert(#matches > 0, ('the pattern %q matched nothing'):format(answer))
    local found = false
    for _, m in ipairs(matches) do
      if m == 'vim.keymap.set()' then
        found = true
      end
    end
    assert(
      found,
      ('%q matched %d tags but not vim.keymap.set(); first few: %s'):format(
        answer,
        #matches,
        table.concat(vim.list_slice(matches, 1, 5), ' ')
      )
    )
  end,
}
