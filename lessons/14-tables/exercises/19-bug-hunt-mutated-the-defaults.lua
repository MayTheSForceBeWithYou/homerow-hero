-- Drill 19. BUG HUNT -- starts FAILING, and it is the commonest real bug in plugin
-- configuration code.
--
-- `setup` is meant to fill in defaults for whatever the caller omits. Run it: the first
-- call works, and the SECOND call inherits the first caller's width.
--
-- Nothing errors. The defaults table is shared by every call, and something wrote into
-- it. Build a new table instead.
return {
  goal = 'Merge options over defaults without the second call inheriting the first',
  hint = 'Which table is being written to, and how many callers share it?',
  check = function()
    local defaults = { width = 80, border = 'rounded' }

    local function setup(opts)
      for k, v in pairs(opts or {}) do
        defaults[k] = v
      end
      return defaults
    end

    local first = setup({ width = 10 })
    local second = setup({})

    assert(first.width == 10, 'the first call should see its own width')
    assert(
      second.width == 80,
      ("the second call leaked the first call's width: got %s"):format(tostring(second.width))
    )
    assert(defaults.width == 80, 'the defaults table itself must be untouched')
  end,
}
