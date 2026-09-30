-- Drill 14. Most v: variables are maintained by Neovim. Return the error message fragment
-- you get for trying to write one.
return {
  goal = 'Return the message fragment for writing a read-only v: variable',
  hint = 'Three words. Read the real error.',
  check = function()
    local answer = nil -- <- your answer
    assert(answer ~= nil, 'DRILL_TODO')

    local ok, err = pcall(function()
      vim.v.count = 5
    end)
    assert(not ok, 'writing v:count should fail')
    assert(
      tostring(err):find(answer, 1, true) ~= nil,
      ('the real error was %q, which does not contain %q'):format(tostring(err), answer)
    )
  end,
}
