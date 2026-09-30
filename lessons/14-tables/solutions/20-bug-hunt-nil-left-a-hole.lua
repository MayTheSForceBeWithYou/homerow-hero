return {
  goal = 'Remove the middle item of a four-element list without leaving a hole',
  hint = 'A table library function shifts the rest down. An assignment does not.',
  check = function()
    local t = { 'a', 'b', 'c', 'd' }

    -- `t[2] = nil` leaves { 'a', nil, 'c', 'd' }: `#t` becomes unspecified and ipairs
    -- stops at the hole. table.remove shifts the tail down and keeps the list dense.
    table.remove(t, 2)

    assert(#t == 3, ('expected a dense list of 3, got #t = %d'):format(#t))
    assert(table.concat(t, '') == 'acd', ('expected "acd", got %q'):format(table.concat(t, '')))
    local seen = 0
    for _ in ipairs(t) do
      seen = seen + 1
    end
    assert(seen == 3, ('ipairs reached only %d elements -- there is a hole'):format(seen))
  end,
}
