-- Drill 02. Numeric options take numbers, not strings. Set the shift width to 2.
return {
  goal = "Set 'shiftwidth' to 2 from Lua",
  check = function()
    vim.o.shiftwidth = 8 -- Neovim's default, so the drill starts from a real change

    error('DRILL_TODO') -- delete this line once you have written your answer

    -- <- your answer: write this line

    assert(vim.o.shiftwidth == 2, ('shiftwidth is %d, not 2'):format(vim.o.shiftwidth))
  end,
}
