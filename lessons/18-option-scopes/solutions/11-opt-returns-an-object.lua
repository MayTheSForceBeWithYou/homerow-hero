-- Drill 11. The debt from lesson 04. Return a list of the two Lua types:
-- { type_of_vim_o_shiftwidth, type_of_vim_opt_shiftwidth }.
return {
  goal = 'Return the Lua types of vim.o.shiftwidth and vim.opt.shiftwidth',
  check = function()
    -- ANSWER_BEGIN
    local answer = { type(vim.o.shiftwidth), type(vim.opt.shiftwidth) }
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer[1] == 'number', 'vim.o gives the value')
    assert(answer[2] == 'table', 'vim.opt gives an Option OBJECT')
  end,
}
