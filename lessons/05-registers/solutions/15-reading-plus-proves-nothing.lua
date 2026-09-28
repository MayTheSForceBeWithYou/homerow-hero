-- Drill 15. Why the obvious test is useless. Write text into the clipboard register
-- with setreg, then read it back -- and observe that the read succeeds regardless
-- of whether any provider is working, because Neovim keeps its own copy.
--
-- Return true if the value read back matches what was written.
return {
  goal = 'Return whether reading the clipboard register back returns what you wrote',
  hint = 'This is why the round trip through Neovim is not evidence of anything.',
  run = function()
    vim.fn.setreg('+', 'HOMEROW_HERO_PROBE')
    return vim.fn.getreg('+') == 'HOMEROW_HERO_PROBE' -- <- your answer
  end,
  value = true,
}
