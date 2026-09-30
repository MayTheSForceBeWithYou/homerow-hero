-- Drill 17. BUG HUNT -- starts FAILING. One character is missing.
--
-- The intent is to append "!" after the first comma on every line. Run it: line 1 is
-- correct and the other two are untouched.
--
-- The macro is not wrong as a sequence of keys -- it did exactly what it says on the
-- line it was recorded on. Look at where the commas sit relative to each other, ask
-- what column repetition one leaves the cursor in, and remember which direction `f`
-- searches.
--
-- Note that drill 16's macro needed no anchor at all. This one does. The difference
-- is the kind of keystroke involved.
return {
  goal = 'Append "!" after the first comma on every line',
  hint = 'One keystroke here inherits the cursor column. Give it a known one to start from.',
  start = { 'aaa,bbb', 'a,bbbbb', 'aa,bbbb' },
  cursor = { 1, 0 },
  want = { 'aaa,!bbb', 'a,!bbbbb', 'aa,!bbbb' },
  setup = function()
    vim.fn.setreg('q', '')
  end,
  keys = 'qqf,a!<Esc>jq99@q',
}
