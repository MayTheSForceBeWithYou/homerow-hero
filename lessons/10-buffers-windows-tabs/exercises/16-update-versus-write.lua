-- Drill 16. In an :argdo pipeline you want the write command that only writes when the
-- buffer was actually modified, so untouched files keep their timestamps.
--
-- Return its name, without a colon.
return {
  goal = 'Return the write command that only writes a modified buffer',
  run = function()
    return nil -- <- your answer
  end,
  value = 'update',
}
