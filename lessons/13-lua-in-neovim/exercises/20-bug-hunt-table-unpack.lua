-- Drill 20. BUG HUNT -- starts FAILING.
--
-- The intent is to spread a list into three return values. The spelling used is the one
-- every modern Lua tutorial teaches -- and it does not exist here, so the call fails
-- with the name error from drill 16.
--
-- Fix it so it works under LuaJIT. If you want it to work on both, drill 07 has the
-- portable idiom.
return {
  goal = 'Spread the list { 10, 20, 30 } into three values',
  hint = 'Read the error. Then remember which Lua this is.',
  check = function()
    local answer = { table.unpack({ 10, 20, 30 }) }

    assert(#answer == 3, ('expected three values, got %d'):format(#answer))
    assert(answer[1] == 10 and answer[3] == 30, 'expected 10, 20, 30')
  end,
}
