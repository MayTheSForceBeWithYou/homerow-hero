-- Drill 19. With no command, :g default is :p -- it prints the matching lines. That
-- makes it a way to check a pattern before acting on it.
--
-- Run it and confirm the buffer is UNCHANGED: this command only looks.
return {
  goal = 'List the lines a pattern matches without modifying the buffer',
  hint = 'Leave the command off entirely.',
  start = { 'aa', 'bb', 'aa' },
  cursor = { 1, 0 },
  want = { 'aa', 'bb', 'aa' },
  keys = '', -- <- your answer
}
