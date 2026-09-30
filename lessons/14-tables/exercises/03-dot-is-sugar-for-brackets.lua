-- Drill 03. `t.name` and `t['name']` are the same access. Return true if they resolve to
-- the same value for a key that dot syntax can express.
return {
  goal = 'Return whether dot and bracket access give the same value',
  check = function()
    local t = { name = 'hero' }

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == true, 'dot syntax is sugar for a string key')
  end,
}
