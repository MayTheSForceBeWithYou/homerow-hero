-- Drill 16. The judgement the lesson closes on. For state only your own Lua reads, a
-- module-level local beats vim.g -- no collision risk, no copy-on-read, and it holds a live
-- table you CAN mutate.
--
-- Build a closure-based counter and return its first two values, to show the live-table
-- property vim.g lacks.
return {
  goal = 'Build private state with a local and return two successive values',
  hint = "Lesson 15's counter.",
  check = function()
    -- ANSWER_BEGIN
    local function make()
      local state = { n = 0 }
      return function()
        state.n = state.n + 1
        return state.n
      end
    end
    -- ANSWER_END

    assert(make ~= nil, 'DRILL_TODO')
    local next_value = make()
    local answer = { next_value(), next_value() }
    assert(
      answer[1] == 1 and answer[2] == 2,
      ('expected 1,2 -- got %s,%s'):format(tostring(answer[1]), tostring(answer[2]))
    )
  end,
}
