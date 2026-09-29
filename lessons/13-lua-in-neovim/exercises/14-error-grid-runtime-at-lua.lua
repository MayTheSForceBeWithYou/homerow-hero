-- Drill 14. The other half of the typed row: a RUNTIME error at :lua.
return {
  goal = 'Return the error code for a runtime error in a typed :lua command',
  check = function()
    local answer = nil -- <- your answer
    assert(answer ~= nil, 'DRILL_TODO')

    local ok, err = pcall(vim.cmd, 'lua error("boom")')
    assert(not ok, 'that should have raised')
    assert(
      tostring(err):find(answer, 1, true) ~= nil,
      ('the real error was %q, which does not contain %q'):format(tostring(err), answer)
    )
  end,
}
