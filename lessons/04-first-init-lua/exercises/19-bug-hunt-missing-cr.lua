-- Drill 19. BUG HUNT -- starts FAILING.
--
-- The mapping is meant to replace every `a` on the line with `b`. The rhs is a
-- correct Ex command and the mapping is correctly installed -- yet the buffer does
-- not change.
--
-- A string rhs means "type these keys". Ask what is missing from the end of it.
return {
  goal = 'Make <F2> replace every a on the line with b',
  hint = 'Typing a command is not the same as submitting it.',
  start = { 'banana' },
  cursor = { 1, 0 },
  want = { 'bbnbnb' },
  setup = function()
    pcall(vim.keymap.del, 'n', '<F2>')
    vim.keymap.set('n', '<F2>', ':s/a/b/g', { desc = 'drill 19' })
  end,
  keys = '<F2>',
}
