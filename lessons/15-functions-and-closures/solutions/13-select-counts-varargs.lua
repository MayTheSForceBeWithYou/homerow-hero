-- Drill 13. Counting varargs. One way copes with a nil argument and one does not, because
-- a nil in a table constructor makes a hole (lesson 14).
--
-- Return a list: { correct_count, the_unreliable_count } for the arguments 1, nil, 3.
return {
  goal = 'Return the correct vararg count and the unreliable one',
  hint = 'One uses select; the other builds a table first.',
  check = function()
    local function counts(...)
      -- ANSWER_BEGIN
      return { select('#', ...), #{ ... } }
      -- ANSWER_END
    end

    local answer = counts(1, nil, 3)
    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer[1] == 3, ('select("#", ...) should say 3, got %s'):format(tostring(answer[1])))
    assert(answer[2] ~= 3, 'the table form should NOT agree -- the nil made a hole')
  end,
}
