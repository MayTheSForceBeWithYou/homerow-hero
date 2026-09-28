-- Drill 14. The measured trap from the lesson. `has('clipboard_working')` returned
-- 1 on the author's machine while nothing reached the OS clipboard.
--
-- Return what that 1 actually establishes, as one of these exact strings:
--   'a provider executable was found'
--   'a transfer to the OS succeeded'
return {
  goal = 'Return what has("clipboard_working") actually establishes',
  run = function()
    return nil -- <- your answer
  end,
  value = 'a provider executable was found',
}
