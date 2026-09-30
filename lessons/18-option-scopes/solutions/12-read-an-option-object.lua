-- Drill 12. Two correct ways to read a number back. Return them as a list, using vim.o for
-- the first and the Option object's method for the second.
return {
  goal = 'Read shiftwidth as a number two ways and return both',
  hint = 'The object has a method for it.',
  check = function()
    vim.api.nvim_set_option_value('shiftwidth', 5, { scope = 'global' })
    vim.api.nvim_set_option_value('shiftwidth', 5, { buf = 0 })

    -- ANSWER_BEGIN
    local answer = { vim.o.shiftwidth, vim.opt.shiftwidth:get() }
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer[1] == 5, ('vim.o should give 5, got %s'):format(tostring(answer[1])))
    assert(answer[2] == 5, (':get() should give 5, got %s'):format(tostring(answer[2])))
  end,
}
