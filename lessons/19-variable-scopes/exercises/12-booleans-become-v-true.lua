-- Drill 12. A Lua boolean goes through Vimscript's type system. Return what Vimscript
-- echoes for a global set to Lua's true.
return {
  goal = 'Return what Vimscript echoes for a global assigned Lua true',
  hint = 'It is not "1".',
  check = function()
    vim.g.hero_d12 = true

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == 'v:true', ('expected v:true, got %q'):format(tostring(answer)))
    -- And it comes back to Lua as a real boolean.
    assert(vim.g.hero_d12 == true and type(vim.g.hero_d12) == 'boolean', 'round-trips as a boolean')
    vim.g.hero_d12 = nil
  end,
}
