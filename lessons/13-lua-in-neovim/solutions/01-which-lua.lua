-- Drill 01. Return what `_VERSION` reports inside Neovim. Read it from the global
-- rather than typing the string, so the drill would notice if it ever changed.
return {
  goal = 'Return the Lua version string Neovim reports',
  hint = 'It is a global, and the answer is NOT the version of the lua on your PATH.',
  check = function()
    -- ANSWER_BEGIN
    local answer = _VERSION
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == _VERSION, ('_VERSION is %q; you said %q'):format(_VERSION, tostring(answer)))
    assert(answer == 'Lua 5.1', 'LuaJIT identifies as Lua 5.1')
  end,
}
