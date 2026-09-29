-- Drill 16. The judgement call. Return which of these two a config should let fail LOUDLY,
-- as the string 'required' or 'optional'.
--
-- The reasoning matters more than the answer: a failure that makes everything after it
-- wrong should stop the chunk, because a notification scrolls past and a silently wrong
-- config is harder to diagnose than a loud one.
return {
  goal = 'Return which kind of module should be left unguarded',
  run = function()
    return 'required' -- <- your answer
  end,
  value = 'required',
}
