-- Drill 09. `:helpgrep` searches the help TEXT rather than the tags, and it fills the
-- quickfix list -- so every navigation command from lesson 11 works on it unchanged.
--
-- Return the number of quickfix entries the search produces.
return {
  goal = 'Return how many quickfix entries a :helpgrep produces',
  hint = 'The same getqflist() you used in lesson 11.',
  check = function()
    vim.fn.setqflist({})
    vim.cmd('silent helpgrep nvim_buf_set_lines')

    -- ANSWER_BEGIN
    local answer = #vim.fn.getqflist()
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    local actual = #vim.fn.getqflist()
    assert(
      answer == actual,
      ('the list holds %d entries; you said %s'):format(actual, tostring(answer))
    )
    assert(actual > 1, 'the search should have found several mentions')
  end,
}
