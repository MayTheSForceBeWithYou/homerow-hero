-- Drill 17. The mechanism behind "strict mode" plugins: a metatable on the global table
-- turns an accidental global into an immediate error.
--
-- Install one, then return true if writing a new global raises.
return {
  goal = 'Make an accidental global raise, using a metatable on the global table',
  hint = 'The metamethod for assigning a key that does not exist yet.',
  check = function()
    local answer = nil -- <- your answer

    local mt = getmetatable(_G)
    assert(mt ~= nil, 'DRILL_TODO')
    local ok, err = pcall(function()
      hero_sneaky_probe = 1
    end)
    setmetatable(_G, nil)
    assert(not ok, 'writing a new global should have raised')
    assert(
      tostring(err):find('accidental', 1, true),
      ('expected your message, got %q'):format(tostring(err))
    )
  end,
}
