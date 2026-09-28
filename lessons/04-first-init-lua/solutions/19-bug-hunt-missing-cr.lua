return {
  goal = 'Make <F2> replace every a on the line with b',
  hint = 'Typing a command is not the same as submitting it.',
  start = { 'banana' },
  cursor = { 1, 0 },
  want = { 'bbnbnb' },
  setup = function()
    pcall(vim.keymap.del, 'n', '<F2>')
    -- Without `<CR>` the mapping typed `:s/a/b/g` onto the command line and left
    -- it there. The rhs is keystrokes, so it needs the keystroke that submits.
    vim.keymap.set('n', '<F2>', ':s/a/b/g<CR>', { desc = 'drill 19' })
  end,
  keys = '<F2>',
}
