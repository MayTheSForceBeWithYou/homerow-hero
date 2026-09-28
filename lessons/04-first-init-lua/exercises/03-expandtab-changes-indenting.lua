-- Drill 03. Synthesis with lesson 01. Back then, `>>` inserted a literal tab and
-- the drill had to expect "\t", because Neovim's default is 'noexpandtab'.
--
-- Set the two options that make one indent two SPACES instead, in `setup`, then
-- indent the line with the operator from lesson 01.
return {
  goal = 'Make one indent two spaces, then indent the line',
  hint = 'Two options, then the doubled operator from lesson 01.',
  start = { 'flush left' },
  cursor = { 1, 0 },
  want = { '  flush left' },
  setup = function()
    vim.opt.expandtab = true
    vim.opt.shiftwidth = 2
  end,
  keys = '', -- <- your answer
}
