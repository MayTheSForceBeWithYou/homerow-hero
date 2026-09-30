-- Drill 13. Four error codes form a grid: parse or runtime, typed or in a file. Return
-- the code for a PARSE error in a typed :lua command, as a string like 'E9999'.
return {
  goal = 'Return the error code for a parse error in a typed :lua command',
  check = function()
    local answer = nil -- <- your answer
    assert(answer ~= nil, 'DRILL_TODO')

    local ok, err = pcall(vim.cmd, 'lua local x = = 1')
    assert(not ok, 'that should not have compiled')
    assert(
      tostring(err):find(answer, 1, true) ~= nil,
      ('the real error was %q, which does not contain %q'):format(tostring(err), answer)
    )
  end,
}
