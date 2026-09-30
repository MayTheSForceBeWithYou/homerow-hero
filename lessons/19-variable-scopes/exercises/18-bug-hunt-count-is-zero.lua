-- Drill 18. BUG HUNT -- starts FAILING.
--
-- The helper multiplies by the count the user typed, so `3<something>` should give three.
-- With NO count typed it should behave as one -- and instead it gives zero, so the caller
-- does nothing at all.
--
-- Two v: variables differ in exactly this case. Pick the other one.
return {
  goal = 'Return a usable multiplier from the typed count, defaulting to one',
  hint = 'One of the pair is 0 with no count and the other is 1.',
  check = function()
    local function multiplier()
      return vim.v.count
    end

    -- No count has been typed in this drill, so the helper must still yield 1.
    assert(
      multiplier() == 1,
      ('with no count typed the multiplier should be 1, got %s'):format(tostring(multiplier()))
    )
  end,
}
