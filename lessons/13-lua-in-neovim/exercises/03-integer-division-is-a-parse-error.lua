-- Drill 03. `7 // 2` is a 5.3 feature. Here it does not even compile, which means you
-- cannot pcall it -- the failure happens at LOAD time, not at call time.
--
-- Return true if loading that expression fails.
return {
  goal = 'Return whether "return 7 // 2" fails to compile',
  hint = 'load() returns nil plus a message when the source will not compile.',
  check = function()
    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == true, 'integer division does not exist in 5.1, so this is a parse error')
    local _, err = load('return 7 // 2')
    assert(
      tostring(err):find('unexpected symbol', 1, true),
      ('expected an unexpected-symbol message, got %q'):format(tostring(err))
    )
  end,
}
