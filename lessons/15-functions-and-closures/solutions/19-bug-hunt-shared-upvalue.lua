return {
  goal = 'Make two togglers that each remember their own saved value',
  hint = 'Where is the captured local declared, and how many closures see it?',
  check = function()
    local function make_toggler(start)
      -- Declared INSIDE the maker, so each call creates a fresh one and each returned
      -- closure captures its own. Hoisted outside, there is a single variable that every
      -- toggler shares -- the same shape as the `3 3 3` loop measurement.
      local saved = nil

      return function()
        if saved == nil then
          saved = start
          return 'stored'
        end
        local was = saved
        saved = nil
        return was
      end
    end

    local a = make_toggler('A')
    local b = make_toggler('B')

    assert(a() == 'stored', 'the first toggler should store its value')
    assert(b() == 'stored', 'the second toggler should store its own value')
    assert(a() == 'A', ('the first should restore "A", got %s'):format(tostring(a())))
    assert(b() == 'B', ('the second should restore "B", got %s'):format(tostring(b())))
  end,
}
