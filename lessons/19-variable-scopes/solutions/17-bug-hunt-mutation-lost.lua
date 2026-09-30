return {
  goal = 'Make a toggle that flips a flag stored in vim.g and persists the change',
  hint = 'Three steps. The third is the one missing.',
  check = function()
    vim.g.hero_d17 = { on = false }

    local function toggle()
      -- Every read of vim.g.hero_d17 builds a NEW Lua table, so assigning a field on it
      -- writes to a temporary that is then discarded. Read it into a local, change that,
      -- and put it back -- vim.g is storage, not a live object.
      local state = vim.g.hero_d17
      state.on = not state.on
      vim.g.hero_d17 = state
      return state.on
    end

    local first = toggle()
    local second = toggle()

    assert(first == true, ('the first call should turn it on, got %s'):format(tostring(first)))
    assert(second == false, ('the second should turn it off, got %s'):format(tostring(second)))
    vim.g.hero_d17 = nil
  end,
}
