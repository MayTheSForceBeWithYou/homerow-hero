-- Drill 19. BUG HUNT -- starts FAILING, and this is the loop-capture bug wearing the
-- clothes it actually wears in a config.
--
-- `make_toggler` is meant to produce independent togglers, each remembering its own saved
-- value. Run it: toggling the second one restores the first one's value, because they
-- share state.
--
-- Nothing errors. Ask how many `saved` variables exist, and how many there should be.
return {
  goal = 'Make two togglers that each remember their own saved value',
  hint = 'Where is the captured local declared, and how many closures see it?',
  check = function()
    local saved = nil

    local function make_toggler(start)
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
