-- Drill 12. `:normal` runs Normal-mode keystrokes from the command line. The usual
-- Ex default applies here -- the current line only.
return {
  goal = 'Append "!" to the current line using :normal',
  start = { 'a', 'b' },
  cursor = { 1, 0 },
  want = { 'a!', 'b' },
  keys = ':normal A!<CR>',
}
