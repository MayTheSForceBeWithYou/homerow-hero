-- Drill 11. The result that catches people who navigate by :{number}. One of these
-- two ways of reaching line 25 records a jump and one does not.
--
-- Return the keystrokes -- as you would type them -- for the version that DOES
-- record a jump, so that <C-o> can bring you back.
return {
  goal = 'Return the way of reaching line 25 that records a jumplist entry',
  hint = 'Check the documented list of jump commands for both spellings.',
  run = function()
    return '25G' -- <- your answer
  end,
  value = '25G',
}
