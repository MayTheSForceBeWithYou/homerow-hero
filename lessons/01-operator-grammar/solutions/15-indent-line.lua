-- Drill 15. `>` is an operator too, and doubling it indents this line.
--
-- Mind what gets inserted. The drill runner starts Neovim with `-u NONE`, where
-- 'expandtab' is off and 'shiftwidth' is 8 -- so one indent is a single TAB
-- character, not eight spaces. That is why `want` below contains `\t`.
return {
  goal = 'Indent the current line by one shiftwidth',
  hint = "With 'expandtab' off, indenting inserts a tab rather than spaces.",
  start = { 'flush left' },
  cursor = { 1, 0 },
  want = { '\tflush left' },
  keys = '>>',
}
