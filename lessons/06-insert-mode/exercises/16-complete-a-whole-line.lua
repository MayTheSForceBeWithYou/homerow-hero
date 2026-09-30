-- Drill 16. Completion is not only words. Complete an entire line from one that
-- already exists, indentation included.
return {
  goal = 'Complete "  fu" into the whole matching line above it',
  hint = 'The submode prefix, then the key for a line.',
  start = { '  full line here', '  fu' },
  cursor = { 2, 3 },
  want = { '  full line here', '  full line here' },
  keys = '', -- <- your answer
}
