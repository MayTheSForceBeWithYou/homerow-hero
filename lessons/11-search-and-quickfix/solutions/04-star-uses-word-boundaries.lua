-- Drill 04. `*` searches for the word under the cursor wrapped in word boundaries, so
-- it will not match a longer identifier containing it.
--
-- Return the pattern `*` builds for the word "alpha" -- exactly as it appears on the
-- command line, backslashes included.
return {
  goal = 'Return the pattern that * builds for the word alpha',
  hint = 'Two escapes, one either side.',
  run = function()
    return '\\<alpha\\>' -- <- your answer
  end,
  value = '\\<alpha\\>',
}
