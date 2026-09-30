-- Drill 08. Asking for a tag that does not exist says so plainly. Return the error
-- number, as a string like 'E999'.
return {
  goal = 'Return the error number for a help tag that does not exist',
  check = function()
    local answer = 'E149' -- <- your answer
    assert(answer ~= nil, 'DRILL_TODO')

    local ok, err = pcall(vim.cmd, 'help zz_no_such_tag_anywhere')
    assert(not ok, 'an unknown tag should fail')
    assert(
      tostring(err):find(answer, 1, true) ~= nil,
      ('the real error was %q, which does not contain %q'):format(tostring(err), answer)
    )
  end,
}
