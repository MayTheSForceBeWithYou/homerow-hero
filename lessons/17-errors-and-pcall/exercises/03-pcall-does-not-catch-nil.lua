-- Drill 03. `pcall` reports whether something RAISED. A function that signals failure by
-- returning nil has not raised -- so ok is true.
--
-- Return { ok, value } for a protected call to a function that returns nil.
return {
  goal = 'Protect a function that returns nil and return the verdict and the value',
  check = function()
    local function returns_nil()
      return nil
    end

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer[1] == true, 'returning nil is not raising, so ok is TRUE')
    assert(answer[2] == nil, 'and the nil comes back as the result')
  end,
}
