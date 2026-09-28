-- Drill 20. BUG HUNT -- starts FAILING, and it fails on something other than the
-- buffer. Read the whole failure message.
--
-- The intent is to delete the DROP lines while preserving what was already in the
-- unnamed register -- `setup` put "PRECIOUS" there. The lines are deleted correctly,
-- and the register is gone.
--
-- A bulk delete writes to a register like any other delete. Lesson 05 named the
-- register that discards, and :h :global recommends exactly this.
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
  keys = ':g/DROP/d<CR>',
}
