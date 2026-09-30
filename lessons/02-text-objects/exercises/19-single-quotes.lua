-- Drill 19. Single quotes and backticks have their own objects. In Lua config
-- files this is the one you reach for most.
return {
  goal = 'Empty the single-quoted string, keeping the quotes',
  start = { "local name = 'old value'" },
  cursor = { 1, 16 },
  want = { "local name = ''" },
  keys = '', -- <- your answer
}
