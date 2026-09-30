-- Drill 20. BUG HUNT -- starts FAILING.
--
-- The intent is to compute a value from an option: half the shift width, rounded down.
-- Run it: the arithmetic does not raise -- `+` and friends are defined on an Option -- but
-- the result is not a number and the format call at the end blows up.
--
-- `vim.opt` is for WRITING. There are two correct ways to read a number back.
return {
  goal = 'Compute half the shift width as a number',
  hint = 'One of the five tables gives a value; the Option object has a method.',
  check = function()
    vim.api.nvim_set_option_value('shiftwidth', 8, { scope = 'global' })
    vim.api.nvim_set_option_value('shiftwidth', 8, { buf = 0 })

    local width = vim.opt.shiftwidth

    local half = math.floor(width / 2)
    assert(half == 4, ('expected 4, got %s'):format(tostring(half)))
    assert(string.format('%d', half) == '4', 'and it must format as a number')
  end,
}
