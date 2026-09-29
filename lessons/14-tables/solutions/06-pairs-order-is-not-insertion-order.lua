-- Drill 06. `pairs` order is UNSPECIFIED, and the honest consequence is subtler than
-- "it differs from insertion order".
--
-- Measured across three sessions of the same program, two iterated in exactly insertion
-- order and the third did not. Within any one session the order is stable -- LuaJIT
-- seeds its string hashing per process, so it varies between runs and not inside one.
--
-- That means a drill cannot assert a mismatch: it would pass most of the time and fail
-- occasionally, which is worse than no drill. So assert what IS reliable -- that two
-- iterations in one session agree -- and take the across-session warning from the lesson.
--
-- Return true if iterating the same table twice gives the same order.
return {
  goal = 'Return whether two pairs iterations of one table agree within a session',
  hint = 'Collect the keys twice and compare the two sequences.',
  check = function()
    local t = {}
    for _, k in ipairs({ 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight' }) do
      t[k] = true
    end

    local function order()
      local acc = {}
      for k in pairs(t) do
        acc[#acc + 1] = k
      end
      return table.concat(acc, ' ')
    end

    -- ANSWER_BEGIN
    local answer = order() == order()
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == true, 'within one session the order is stable')
    -- And the part you must NOT rely on: nothing here guarantees it equals insertion
    -- order, and across sessions it genuinely changes. Drill 07 is the fix.
  end,
}
