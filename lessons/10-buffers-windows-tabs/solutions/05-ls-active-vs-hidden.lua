-- Drill 05. Two flags in the same column describe a loaded buffer. Return them as a
-- list of two strings: first the one meaning "loaded AND visible", then the one
-- meaning "loaded but not displayed".
return {
  goal = 'Return the active flag then the hidden flag, in that order',
  hint = 'Both are single lowercase letters.',
  run = function()
    return { 'a', 'h' } -- <- your answer
  end,
  value = { 'a', 'h' },
}
