-- Drill 16. The reference trap applied to a module-level defaults table -- one of the
-- commonest real bugs in plugin configuration code.
--
-- `setup` is called twice with different options. Write it so the SECOND call does not
-- inherit the first one's values.
return {
  goal = 'Write a setup that merges options without mutating the shared defaults',
  hint = 'Build a new table. Never write into defaults.',
  check = function()
    local defaults = { width = 80, border = 'rounded' }

    local function setup(opts)
      error('DRILL_TODO') -- delete this line once you have written your answer

      return nil -- <- your answer
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
