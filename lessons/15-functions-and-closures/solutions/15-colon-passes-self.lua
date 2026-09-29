-- Drill 15. `obj:get()` is sugar for `obj.get(obj)`. Define a method with the colon and
-- return the value it reads from self.
return {
  goal = 'Define a method with colon syntax and return the field it reads',
  hint = 'The colon in the definition adds a hidden parameter.',
  check = function()
    local obj = { n = 5 }

    -- ANSWER_BEGIN
    function obj:get()
      return self.n
    end
    -- ANSWER_END

    assert(obj.get ~= nil, 'DRILL_TODO')
    assert(obj:get() == 5, ('expected 5, got %s'):format(tostring(obj:get())))
    -- And the desugaring: calling it with a dot and passing the receiver is the same.
    assert(obj.get(obj) == 5, 'obj:get() should be sugar for obj.get(obj)')
  end,
}
