-- Drill 17. BUG HUNT -- starts FAILING, and it is this lesson's worst trap: no error, no
-- effect, and the code reads perfectly.
--
-- The toggle is meant to flip a stored flag on each call. Run it: every call sees `false`
-- and the flag never changes.
--
-- Nothing raises, because every individual step is legal. Ask what a READ of a table stored
-- in vim.g actually produces.
return {
  goal = 'Make a toggle that flips a flag stored in vim.g and persists the change',
  hint = 'Three steps. The third is the one missing.',
  check = function()
    vim.g.hero_d17 = { on = false }

    local function toggle()
      vim.g.hero_d17.on = not vim.g.hero_d17.on
      return vim.g.hero_d17.on
    end

    local first = toggle()
    local second = toggle()

    assert(first == true, ('the first call should turn it on, got %s'):format(tostring(first)))
    assert(second == false, ('the second should turn it off, got %s'):format(tostring(second)))
    vim.g.hero_d17 = nil
  end,
}
