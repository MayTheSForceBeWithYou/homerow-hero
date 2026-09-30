return {
  goal = 'Compute half the shift width as a number',
  hint = 'One of the five tables gives a value; the Option object has a method.',
  check = function()
    vim.api.nvim_set_option_value('shiftwidth', 8, { scope = 'global' })
    vim.api.nvim_set_option_value('shiftwidth', 8, { buf = 0 })

    -- `vim.opt.shiftwidth` is an Option OBJECT, not a number. `vim.o` gives the value
    -- directly; `vim.opt.shiftwidth:get()` is the other correct spelling.
    local width = vim.o.shiftwidth

    local half = math.floor(width / 2)
    assert(half == 4, ('expected 4, got %s'):format(tostring(half)))
    assert(string.format('%d', half) == '4', 'and it must format as a number')
  end,
}
