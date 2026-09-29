-- Drill 16. The phrase to key on. Calling a name that does not exist fails BEFORE the
-- arguments are examined -- so "(a nil value)" is always a name problem, never an
-- argument problem.
--
-- Return the substring of the error message that tells you this.
return {
  goal = 'Return the error-message fragment meaning "this name does not exist"',
  hint = 'Four words, in parentheses.',
  check = function()
    local answer = nil -- <- your answer
    assert(answer ~= nil, 'DRILL_TODO')

    local ok, err = pcall(function()
      return vim.api.nvim_no_such_function_at_all()
    end)
    assert(not ok, 'calling a nonexistent field should fail')
    assert(
      tostring(err):find(answer, 1, true) ~= nil,
      ('the real error was %q, which does not contain %q'):format(tostring(err), answer)
    )
  end,
}
