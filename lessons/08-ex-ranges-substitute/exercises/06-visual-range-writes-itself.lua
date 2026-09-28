-- Drill 06. Select the lines, press colon, and Neovim PREFILLS the range from the
-- lesson-03 marks that store the selection -- so you type only the command.
--
-- Do not type the range yourself here. Pressing `:` in Visual mode has already put
-- `'<,'>` on the command line; typing it again gives you `:'<,'>'<,'>s/…`, which is
-- not a valid command and silently does nothing.
return {
  goal = 'Select lines 2 and 3 and substitute on only those lines',
  hint = 'Press : while still in Visual mode, then type only the command -- no range.',
  start = { 'one a', 'two a', 'three a', 'four a', 'five a' },
  cursor = { 2, 0 },
  want = { 'one a', 'two X', 'three X', 'four a', 'five a' },
  keys = '', -- <- your answer
}
