-- Drill 13. Give it a range and it runs once per line.
return {
  goal = 'Append "!" to every line using :normal with a range',
  start = { 'a', 'b' },
  cursor = { 1, 0 },
  want = { 'a!', 'b!' },
  keys = '', -- <- your answer
}
