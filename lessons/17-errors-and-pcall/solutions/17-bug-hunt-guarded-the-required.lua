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
      -- Unguarded: a failure here makes everything after it wrong, so it should stop the
      -- chunk rather than be survived. The optional one keeps its guard.
      load_required()
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
