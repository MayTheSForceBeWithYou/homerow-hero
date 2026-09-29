-- Drill 09. The expensive asymmetry. Formatting a non-whole number with %d truncates
-- here and RAISES in Lua 5.4 and 5.5 -- so a snippet verified in a shell REPL can be
-- wrong in your config, silently.
--
-- Return what string.format('%d', 7/2) produces here.
return {
  goal = "Return what string.format('%d', 7/2) gives inside Neovim",
  hint = 'It does not error. That is the problem.',
  check = function()
    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == '3', ('expected the silently truncated "3", got %q'):format(tostring(answer)))
    -- And confirm it really did not raise, which is the point.
    local ok = pcall(string.format, '%d', 7 / 2)
    assert(ok, 'LuaJIT should not raise here -- 5.4 would')
  end,
}
