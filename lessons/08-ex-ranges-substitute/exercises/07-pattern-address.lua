-- Drill 07. An address can be a pattern: the next line that matches it.
return {
  goal = 'Substitute on the next line containing "three", without using its number',
  hint = 'Delimit the pattern with slashes where a line number would go.',
  start = { 'one a', 'two a', 'three a', 'four a', 'five a' },
  cursor = { 1, 0 },
  want = { 'one a', 'two a', 'three X', 'four a', 'five a' },
  keys = '', -- <- your answer
}
