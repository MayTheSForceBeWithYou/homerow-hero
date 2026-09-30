-- Drill 04. `error` prepends a file and line. Return true if the default form includes a
-- colon-separated position and the suppressed form does not.
return {
  goal = 'Compare error with and without position information',
  hint = 'The second argument to error is a level; one value of it suppresses position.',
  check = function()
    -- ANSWER_BEGIN
    local _, with = pcall(function()
      error('plain')
    end)
    local _, without = pcall(function()
      error('plain', 0)
    end)
    local answer = { with, without }
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(
      tostring(answer[1]):match(':%d+: plain$'),
      ('expected a position prefix, got %q'):format(tostring(answer[1]))
    )
    assert(answer[2] == 'plain', ('expected a bare message, got %q'):format(tostring(answer[2])))
  end,
}
