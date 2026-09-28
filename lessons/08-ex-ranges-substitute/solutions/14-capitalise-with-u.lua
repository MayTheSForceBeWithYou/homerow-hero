-- Drill 14. The capitalisation idiom worth keeping: match each word's first
-- character and uppercase it.
return {
  goal = 'Capitalise the first letter of every word on the line',
  hint = 'Match the start of a word, and uppercase the next character of the replacement.',
  start = { 'hello world' },
  cursor = { 1, 0 },
  want = { 'Hello World' },
  keys = ':s/\\<\\w/\\u&/g<CR>',
}
