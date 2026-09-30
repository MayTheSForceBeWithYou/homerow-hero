-- Drill 06. You cannot type a tag you do not know, but you can type a prefix. Return
-- the number of help tags that complete from the prefix "vim.keymap".
--
-- vim.fn.getcompletion(prefix, 'help') is what <Tab> uses on the command line.
return {
  goal = 'Return how many help tags complete from the prefix "vim.keymap"',
  hint = "getcompletion takes the prefix and the completion type 'help'.",
  check = function()
    -- ANSWER_BEGIN
    local answer = #vim.fn.getcompletion('vim.keymap', 'help')
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    local actual = #vim.fn.getcompletion('vim.keymap', 'help')
    assert(answer == actual, ('there are %d matches; you said %s'):format(actual, tostring(answer)))
    assert(actual >= 3, 'expected at least the module plus set() and del()')
  end,
}
