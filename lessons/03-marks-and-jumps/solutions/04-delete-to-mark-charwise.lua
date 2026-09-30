-- Drill 04. Same mark, same operator, the position-addressed spelling -- and a
-- completely different kind of deletion. It runs charwise from the cursor to the
-- mark's column and joins what is left.
--
-- Start the cursor at line 1 column 1 so the first character survives. Predict the
-- result before running it, then compare with drill 03.
return {
  goal = 'From line 1 column 1, delete charwise up to the marked position',
  hint = 'Same operator as drill 03, the other mark spelling.',
  start = { 'aaa', 'bbb', 'ccc', 'ddd' },
  cursor = { 3, 1 },
  want = { 'acc', 'ddd' },
  keys = 'magg0ld`a',
}
