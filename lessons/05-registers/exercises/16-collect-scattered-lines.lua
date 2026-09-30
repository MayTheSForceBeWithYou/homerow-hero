-- Drill 16. The move that has no comfortable alternative. Collect the three TODO
-- lines -- and only those -- into one register, then put them all together after
-- the last line.
--
-- The lines are not adjacent, so a single linewise yank cannot do it.
return {
  goal = 'Collect the three TODO lines into one register and put them after the last line',
  hint = 'Yank into the register once, then append into it.',
  start = { 'TODO a', 'noise', 'TODO b', 'noise', 'TODO c', 'end' },
  cursor = { 1, 0 },
  want = { 'TODO a', 'noise', 'TODO b', 'noise', 'TODO c', 'end', 'TODO a', 'TODO b', 'TODO c' },
  setup = function()
    vim.fn.setreg('t', '')
  end,
  -- Register `t`, so the append form is the capital of that same letter: `"T`.
  keys = '', -- <- your answer
}
