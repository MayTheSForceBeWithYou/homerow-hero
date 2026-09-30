-- Drill 12. A common mistaken belief. `K` looks up the word under the cursor using an
-- option, and that option's default is not the help system.
--
-- Return the option's name, without quotes, and the check shows you its value.
return {
  goal = 'Return the option that K uses to look up a word',
  hint = 'It is not a mapping -- K is built in and consults an option.',
  check = function()
    local answer = nil -- <- your answer
    assert(answer ~= nil, 'DRILL_TODO')

    local ok, value = pcall(vim.api.nvim_get_option_value, answer, {})
    assert(ok, ('%q is not an option'):format(answer))
    assert(
      value == ':Man',
      ("expected the default ':Man'; %s is %q"):format(answer, tostring(value))
    )
    -- And confirm K really is built in rather than mapped.
    assert(vim.fn.maparg('K', 'n') == '', 'K should not be a mapping under -u NONE')
  end,
}
