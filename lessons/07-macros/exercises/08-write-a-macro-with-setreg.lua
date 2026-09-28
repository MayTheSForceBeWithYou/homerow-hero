-- Drill 08. Because a macro is a register, you can build one without recording.
-- `setup` writes a macro into z with setreg; replay it three times.
return {
  goal = 'Replay the macro that setup wrote into register z, three times',
  hint = 'Nothing to record -- the macro already exists.',
  start = { 'p', 'q', 'r' },
  cursor = { 1, 0 },
  want = { 'p!', 'q!', 'r!' },
  setup = function()
    -- 'A!' then a literal Escape byte, then 'j'
    vim.fn.setreg('z', 'A!\27j')
  end,
  keys = '', -- <- your answer
}
