-- Drill 04. 'ignorecase' and 'smartcase' are a pair. With both on, a lowercase
-- pattern matches any case, but a pattern containing a capital is case-sensitive.
--
-- Set both, then return true if searching for 'error' finds the capitalised word
-- while searching for 'Error' does NOT find the lowercase one.
return {
  goal = 'Set the search-case pair, then confirm both halves of its behaviour',
  hint = 'One option makes search case-insensitive; the other makes a capital opt back out.',
  check = function()
    error('DRILL_TODO') -- delete this line once you have written your answer
    -- <- your answer: write this line
    -- <- your answer: write this line

    vim.cmd('enew!')
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'an Error happened' })
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
    local lowercase_finds_capital = vim.fn.search('error', 'nw') ~= 0

    vim.cmd('enew!')
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'an error happened' })
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
    local capital_finds_lowercase = vim.fn.search('Error', 'nw') ~= 0

    assert(lowercase_finds_capital, "'error' should have matched 'Error' -- is ignorecase on?")
    assert(
      not capital_finds_lowercase,
      "'Error' should NOT have matched 'error' -- is smartcase on?"
    )
  end,
}
