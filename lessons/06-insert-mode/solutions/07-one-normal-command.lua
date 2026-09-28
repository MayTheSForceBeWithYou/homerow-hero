-- Drill 07. The escape hatch that is not <Esc>. Append "!" at the end, then -- still
-- inside the same insertion -- jump to column 1 and type "START".
--
-- If you leave Insert mode and come back, the insertion is broken in two. One key
-- runs exactly one Normal command and returns you.
return {
  goal = 'Append "!" then, without ending the insertion, jump to column 1 and type START',
  hint = 'One Normal command, then straight back to Insert.',
  start = { 'abc def' },
  cursor = { 1, 0 },
  want = { 'STARTabc def!' },
  keys = 'A!<C-o>0START<Esc>',
}
