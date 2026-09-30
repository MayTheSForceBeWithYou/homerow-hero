-- Drill 01. `pcall` returns a boolean plus either the result or the error. Call something
-- that succeeds and return both values as a list: { ok, value }.
return {
  goal = 'Protect a successful call and return the verdict and the value',
  check = function()
    local function fine()
      return 'fine'
    end

    -- ANSWER_BEGIN
    local ok, value = pcall(fine)
    local answer = { ok, value }
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer[1] == true, 'a successful call gives true')
    assert(answer[2] == 'fine', ('expected the return value, got %s'):format(tostring(answer[2])))
  end,
}
