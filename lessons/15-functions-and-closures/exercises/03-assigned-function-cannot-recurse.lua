-- Drill 03. The other form compiles the body while the name is still undeclared, so the
-- recursive reference becomes a GLOBAL lookup -- and fails.
--
-- Return the word that appears in the error message where you expected "local".
return {
  goal = 'Return the word the error uses for a name you thought was local',
  hint = 'Read the real message the check produces.',
  check = function()
    local answer = nil -- <- your answer
    assert(answer ~= nil, 'DRILL_TODO')

    local chunk = load([[
      local fact = function(n) if n <= 1 then return 1 end return n * fact(n-1) end
      return fact(5)
    ]])
    local ok, err = pcall(chunk)
    assert(not ok, 'that form should not be able to recurse')
    assert(
      tostring(err):find(answer, 1, true) ~= nil,
      ('the real error was %q, which does not contain %q'):format(tostring(err), answer)
    )
  end,
}
