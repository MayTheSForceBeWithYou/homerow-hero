-- Drill 18. Lua 5.2 added a function that packs varargs into a table WITH a reliable
-- count, which would solve drill 13 cleanly. Return whether it exists here.
return {
  goal = 'Return whether table.pack exists in this Lua',
  check = function()
    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == false, 'table.pack is 5.2+; LuaJIT is 5.1, so select("#", ...) is the idiom')
  end,
}
