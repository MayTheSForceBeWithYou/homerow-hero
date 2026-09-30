return {
  goal = 'Collect all three returned values along with a trailing marker',
  hint = 'A multi-value call keeps every value in exactly one position.',
  check = function()
    local function multi()
      return 1, 2, 3
    end

    -- A multi-value call is adjusted to ONE value unless it is last, so `{ multi(), 'end' }`
    -- silently drops the 2 and the 3. Expand it in the last position and append after.
    local answer = { multi() }
    answer[#answer + 1] = 'end'

    assert(#answer == 4, ('expected four elements, got %d'):format(#answer))
    assert(
      table.concat(answer, ',') == '1,2,3,end',
      ('expected 1,2,3,end -- got %s'):format(table.concat(answer, ','))
    )
  end,
}
