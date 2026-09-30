-- Drill 06. Assigning nil deletes the variable -- the same operation as :unlet. Return the
-- result of exists() after deleting one.
return {
  goal = 'Delete a global and return what exists() reports for it',
  hint = "exists() answers with 1 or 0, not a boolean (lesson 00's trap)."
    .. ' The variable name goes in as a string with its prefix.',
  check = function()
    vim.g.hero_d06 = 'here'
    assert(vim.fn.exists('g:hero_d06') == 1, 'sanity: it should exist first')

    -- ANSWER_BEGIN
    vim.g.hero_d06 = nil
    local answer = vim.fn.exists('g:hero_d06')
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == 0, ('expected 0 after deletion, got %s'):format(tostring(answer)))
  end,
}
