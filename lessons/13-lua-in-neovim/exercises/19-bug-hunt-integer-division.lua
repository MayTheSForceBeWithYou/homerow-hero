-- Drill 19. BUG HUNT -- starts FAILING, and it fails in an unusual way: the drill file
-- itself will not LOAD, so the runner reports BROKEN rather than FAIL.
--
-- That is the lesson. `//` is not a runtime error you can pcall around -- it is a parse
-- error, so the whole chunk is rejected before any of it runs. A single `//` anywhere
-- in a config file takes the entire file with it.
--
-- The intent is half of 7, rounded down.
return {
  goal = 'Return 7 divided by 2, rounded down',
  hint = 'Integer division arrived in Lua 5.3. Neovim runs 5.1.',
  check = function()
    local answer = 7 // 2

    assert(answer == 3, ('expected 3, got %s'):format(tostring(answer)))
  end,
}
