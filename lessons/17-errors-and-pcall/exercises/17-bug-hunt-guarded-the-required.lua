-- Drill 17. BUG HUNT -- starts FAILING, and this one is a judgement error rather than a
-- typo. The code is defensible-looking and that is the problem.
--
-- The loader guards BOTH modules, so a failure in the one that sets the leader key is
-- survived -- and the config carries on and binds every mapping to the wrong leader. That
-- is lesson 04's failure reached by a route that is harder to diagnose, because the
-- notification scrolls past.
--
-- Make the required module fail loudly. The optional one may keep its guard.
return {
  goal = 'Let a failure in the required module stop the loader instead of being survived',
  hint = 'Which failure makes everything after it wrong?',
  check = function()
    local calls = {}
    local function load_required()
      calls[#calls + 1] = 'required'
      error('options module is broken')
    end
    local function load_optional()
      calls[#calls + 1] = 'optional'
      error('optional module absent')
    end

    local function loader()
      pcall(load_required)
      pcall(load_optional)
    end

    local ok = pcall(loader)
    assert(not ok, 'a failure in the required module must propagate out of the loader')
    assert(calls[1] == 'required', 'the required module is attempted first')
    assert(
      #calls == 1,
      ('nothing should run after the required module failed, ran %d'):format(#calls)
    )
  end,
}
