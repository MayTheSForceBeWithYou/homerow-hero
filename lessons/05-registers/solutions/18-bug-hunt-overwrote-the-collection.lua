return {
  goal = 'Collect both TODO lines into register t and put them after the last line',
  hint = 'The same register has two spellings. One replaces; one adds.',
  start = { 'TODO a', 'noise', 'TODO b', 'end' },
  cursor = { 1, 0 },
  want = { 'TODO a', 'noise', 'TODO b', 'end', 'TODO a', 'TODO b' },
  setup = function()
    vim.fn.setreg('t', '')
  end,
  -- The second yank used the lowercase name again, which REPLACES the register. The
  -- capital letter is the same register in append mode.
  keys = '"tyyjj"TyyG"tp',
}
