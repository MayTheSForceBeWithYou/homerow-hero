-- Drill 04. The habit worth building: when you yank something for LATER rather
-- than NEXT, give it a name. Then nothing can clobber it.
--
-- Yank line 1 into register a, delete two lines, and put from a.
return {
  goal = 'Yank line 1 into register a, delete lines, then put from a',
  start = { 'KEEP', 'x', 'y' },
  cursor = { 1, 0 },
  want = { 'KEEP', 'KEEP' },
  setup = function()
    vim.fn.setreg('a', '')
  end,
  keys = '"ayyj2dd"ap',
}
