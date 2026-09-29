-- Drill 06. Build a map one key at a time, then iterate it. Return true if the iteration
-- order DIFFERS from the insertion order.
--
-- Do not take this on trust; the whole point is that the measurement surprises people.
return {
  goal = 'Return whether pairs order differs from insertion order',
  hint = 'Record what you inserted, collect what you iterated, compare the two.',
  check = function()
    local names = { 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight' }
    local t = {}
    for _, k in ipairs(names) do
      t[k] = true
    end

    -- ANSWER_BEGIN
    local iterated = {}
    for k in pairs(t) do
      iterated[#iterated + 1] = k
    end
    local answer = table.concat(iterated, ' ') ~= table.concat(names, ' ')
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == true, 'the two orders should differ -- pairs order is unspecified')
  end,
}
