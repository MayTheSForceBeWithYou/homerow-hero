-- Drill 05. The capital letter is the SAME register in append mode. Collect line 1
-- and line 3 into register a, then put both at the end.
--
-- Registers are global and survive between drills, so `setup` clears a first.
return {
  goal = 'Collect lines 1 and 3 into register a, then put both after the last line',
  hint = 'Yank into the register, then append into it.',
  start = { 'one', 'skip', 'three' },
  cursor = { 1, 0 },
  want = { 'one', 'skip', 'three', 'one', 'three' },
  setup = function()
    vim.fn.setreg('a', '')
  end,
  keys = '"ayyjj"AyyG"ap',
}
