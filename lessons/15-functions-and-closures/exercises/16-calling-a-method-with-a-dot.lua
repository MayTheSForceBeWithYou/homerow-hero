-- Drill 16. Calling a colon-defined method with a dot passes nothing as self. Return the
-- name of the variable the error complains about.
return {
  goal = 'Return the variable name the error names when a method is called with a dot',
  hint = 'Four letters. Read the real message.',
  check = function()
    local obj = { n = 5 }
    function obj:get()
      return self.n
    end

    local answer = nil -- <- your answer
    assert(answer ~= nil, 'DRILL_TODO')

    local ok, err = pcall(function()
      return obj.get()
    end)
    assert(not ok, 'calling it with a dot should fail')
    assert(
      tostring(err):find(answer, 1, true) ~= nil,
      ('the real error was %q, which does not contain %q'):format(tostring(err), answer)
    )
  end,
}
