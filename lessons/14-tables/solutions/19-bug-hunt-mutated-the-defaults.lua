return {
  goal = 'Merge options over defaults without the second call inheriting the first',
  hint = 'Which table is being written to, and how many callers share it?',
  check = function()
    local defaults = { width = 80, border = 'rounded' }

    local function setup(opts)
      -- The broken version looped `defaults[k] = v`, writing into the module-level
      -- table that every caller shares -- so call two inherited call one's options and
      -- the "defaults" drifted from what the source says. Merging into a NEW table
      -- leaves `defaults` alone.
      return vim.tbl_deep_extend('force', defaults, opts or {})
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
