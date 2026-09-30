-- Drill 10. The consequence of drill 09. The SAME put key produces a new line or
-- an inline insertion depending on how the text was captured.
--
-- Capture one character charwise, then put it -- and note that it lands beside the
-- cursor rather than on a line of its own.
return {
  goal = 'Yank one character and put it inline on the next line',
  start = { 'AB', 'CD' },
  cursor = { 1, 0 },
  want = { 'AB', 'CAD' },
  keys = 'yljp',
}
