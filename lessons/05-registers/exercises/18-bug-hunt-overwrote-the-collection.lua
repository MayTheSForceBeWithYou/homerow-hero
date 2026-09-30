-- Drill 18. BUG HUNT -- starts FAILING.
--
-- The intent is to collect both TODO lines into register t and put them together.
-- Run it: only the second one arrives. Each yank replaced the register instead of
-- adding to it.
--
-- The fix is one character, and it is a change of case.
return {
  goal = 'Collect both TODO lines into register t and put them after the last line',
  hint = 'The same register has two spellings. One replaces; one adds.',
  start = { 'TODO a', 'noise', 'TODO b', 'end' },
  cursor = { 1, 0 },
  want = { 'TODO a', 'noise', 'TODO b', 'end', 'TODO a', 'TODO b' },
  setup = function()
    vim.fn.setreg('t', '')
  end,
  keys = '"tyyjj"tyyG"tp',
}
