-- Drill 02. LuaJIT announces itself through a global table that plain Lua does not
-- have. Return true if it is present.
return {
  goal = 'Return whether the LuaJIT global table exists',
  hint = 'Three letters.',
  check = function()
    -- ANSWER_BEGIN
    local answer = jit ~= nil
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == true, 'Neovim runs LuaJIT, so the jit table exists')
    assert(jit.version:find('LuaJIT'), 'sanity: jit.version should name LuaJIT')
  end,
}
