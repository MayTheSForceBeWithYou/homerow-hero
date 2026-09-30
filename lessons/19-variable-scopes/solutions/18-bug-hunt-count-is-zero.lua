return {
  goal = 'Return a usable multiplier from the typed count, defaulting to one',
  hint = 'One of the pair is 0 with no count and the other is 1.',
  check = function()
    local function multiplier()
      -- `v:count` is 0 when no count was typed, which is a useless multiplier. `v:count1`
      -- exists for exactly this: the count, or 1.
      return vim.v.count1
    end

    assert(
      multiplier() == 1,
      ('with no count typed the multiplier should be 1, got %s'):format(tostring(multiplier()))
    )
  end,
}
