-- Drill 09. Put a macro into the buffer as TEXT so you can look at it. In a real
-- editor the Escape byte renders as ^[; here it is the literal "\27".
--
-- Note where it lands. `setreg` with no type argument creates a CHARWISE register
-- (lesson 05), so the put inserts beside the cursor on the current line rather than
-- opening a new one. The buffer ends up with a single line.
return {
  goal = 'Paste the macro in register q into the buffer as text',
  hint = 'This is the ordinary put command with a register name in front of it.',
  start = { '' },
  cursor = { 1, 0 },
  want = { 'A;\27j' },
  setup = function()
    vim.fn.setreg('q', 'A;\27j')
  end,
  keys = '', -- <- your answer
}
