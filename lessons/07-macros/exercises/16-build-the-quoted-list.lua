-- Drill 16. The worked example, done for real. Quote and comma-terminate every
-- line. Two changes per line, so `.` cannot do it -- record a macro.
--
-- Note what this macro does NOT need: an anchor. `I` goes to the first non-blank and
-- `A` to the end of the line whatever column the cursor was in, so both are
-- absolute and the macro is already position-independent. Adding a leading `0` here
-- is harmless and does nothing -- anchoring is the fix for a specific dependency,
-- not a ritual.
--
-- Use a count large enough that you did not have to count the lines.
return {
  goal = 'Wrap every line in single quotes with a trailing comma, using one macro',
  hint = "I'<Esc> then A',<Esc> then move down. Ask whether any keystroke needs an anchor.",
  start = { 'alpha', 'beta', 'gamma' },
  cursor = { 1, 0 },
  want = { "'alpha',", "'beta',", "'gamma'," },
  setup = function()
    vim.fn.setreg('q', '')
  end,
  keys = '', -- <- your answer
}
