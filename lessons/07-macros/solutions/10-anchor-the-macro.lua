-- Drill 10. The habit that makes macros trustworthy. `setup` has written a macro
-- that deletes the character after a semicolon and moves down -- but WITHOUT an
-- anchor it aborts after one line, because the cursor lands on the next semicolon
-- and `f` searches strictly forward.
--
-- Do not fix the macro. Instead replay the anchored version that setup also wrote
-- into register a, three times, and see all three lines processed.
return {
  goal = 'Replay the anchored macro in register a three times',
  start = { 'a;b', 'c;d', 'e;f' },
  cursor = { 1, 0 },
  want = { 'ab', 'cd', 'ef' },
  setup = function()
    vim.fn.setreg('q', 'f;xj') -- fragile: no anchor
    vim.fn.setreg('a', '0f;xj') -- anchored
  end,
  keys = '3@a',
}
