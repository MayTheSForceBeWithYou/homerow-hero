-- Drill 03. A bulk delete writes to the unnamed register like any other delete,
-- which costs you whatever you were carrying. Use lesson 05's black hole so the
-- register survives.
--
-- `setup` puts a sentinel in the unnamed register; the drill asserts it is still
-- there afterwards.
return {
  goal = 'Delete the DROP lines without disturbing the unnamed register',
  hint = 'The delete command takes a register argument.',
  start = { 'keep 1', 'DROP a', 'keep 2', 'DROP b' },
  cursor = { 1, 0 },
  want = { 'keep 1', 'keep 2' },
  want_registers = { ['"'] = 'PRECIOUS' },
  setup = function()
    vim.fn.setreg('"', 'PRECIOUS')
  end,
  keys = '', -- <- your answer
}
