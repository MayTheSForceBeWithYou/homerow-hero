-- Drill 13. The Ex command that *asks* for an option's value rather than setting
-- it. Return it exactly as you would type it, including the option name
-- 'shiftwidth' and whatever punctuation makes it a query.
return {
  goal = 'Return the Ex command that reports the current value of shiftwidth',
  hint = 'One character turns a set into a question.',
  run = function()
    return nil -- <- your answer
  end,
  value = 'set shiftwidth?',
}
