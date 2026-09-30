return {
  goal = 'Spread the list { 10, 20, 30 } into three values',
  hint = 'Read the error. Then remember which Lua this is.',
  check = function()
    -- `table.unpack` is the 5.4 name. In 5.1 it is a global. The portable spelling is
    -- `table.unpack or unpack`, which drill 07 uses.
    local answer = { unpack({ 10, 20, 30 }) }

    assert(#answer == 3, ('expected three values, got %d'):format(#answer))
    assert(answer[1] == 10 and answer[3] == 30, 'expected 10, 20, 30')
  end,
}
