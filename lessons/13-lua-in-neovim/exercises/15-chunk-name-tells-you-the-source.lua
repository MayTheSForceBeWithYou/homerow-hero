-- Drill 15. A recognition rule. The chunk name in an error tells you whether a file is
-- involved at all. Return the exact bracketed chunk name that appears in an error from
-- a typed :lua command.
return {
  goal = 'Return the chunk name that appears in an error from a typed :lua command',
  hint = 'It is bracketed, and it is not a filename.',
  check = function()
    local answer = nil -- <- your answer
    assert(answer ~= nil, 'DRILL_TODO')

    local _, err = pcall(vim.cmd, 'lua error("boom")')
    assert(
      tostring(err):find(answer, 1, true) ~= nil,
      ('the real error was %q, which does not contain %q'):format(tostring(err), answer)
    )
  end,
}
