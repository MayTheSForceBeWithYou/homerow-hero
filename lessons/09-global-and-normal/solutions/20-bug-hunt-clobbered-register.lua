return {
  goal = 'Delete the DROP lines without disturbing the unnamed register',
  hint = 'The delete command accepts a register argument after it.',
  start = { 'keep 1', 'DROP a', 'keep 2', 'DROP b' },
  cursor = { 1, 0 },
  want = { 'keep 1', 'keep 2' },
  want_registers = { ['"'] = 'PRECIOUS' },
  setup = function()
    vim.fn.setreg('"', 'PRECIOUS')
  end,
  -- Naming the black hole register sends the deleted lines nowhere, so the unnamed
  -- register survives. :h :global recommends this and notes it is also faster.
  keys = ':g/DROP/d _<CR>',
}
