-- Drill 02. `local function f` declares the local BEFORE compiling the body, so the body
-- can call it. Write a recursive factorial with that form and return 5!.
return {
  goal = 'Write a recursive factorial using the form that can call itself',
  hint = 'Two words before the name.',
  check = function()
    -- ANSWER_BEGIN
    local function fact(n)
      if n <= 1 then
        return 1
      end
      return n * fact(n - 1)
    end
    -- ANSWER_END

    assert(fact ~= nil, 'DRILL_TODO')
    assert(fact(5) == 120, ('expected 120, got %s'):format(tostring(fact(5))))
  end,
}
