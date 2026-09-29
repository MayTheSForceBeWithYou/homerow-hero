return {
  goal = 'Return 7 divided by 2, rounded down',
  hint = 'Integer division arrived in Lua 5.3. Neovim runs 5.1.',
  check = function()
    -- `//` is a PARSE error under LuaJIT, so it takes the whole file down before
    -- anything runs -- which is why the broken version reports BROKEN, not FAIL.
    local answer = math.floor(7 / 2)

    assert(answer == 3, ('expected 3, got %s'):format(tostring(answer)))
  end,
}
