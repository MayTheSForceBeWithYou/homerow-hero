-- Drill 08. The cheapest navigation in the editor: flip to the alternate buffer --
-- the one marked `#` in a `:ls` listing. Press it twice and you are back.
return {
  goal = 'Toggle to the alternate buffer and back again using the keystroke',
  hint = 'One control keystroke, no command line.',
  check = function()
    vim.cmd('silent! only')
    vim.cmd('edit zz_one.txt')
    vim.cmd('edit zz_two.txt')
    local started_in = vim.fn.expand('%:t')

    error('DRILL_TODO') -- delete this line once you have written your answer

    -- <- your answer: write this line

    assert(keys ~= nil, 'DRILL_TODO')
    local tc = vim.api.nvim_replace_termcodes(keys, true, false, true)
    vim.api.nvim_feedkeys(tc, 'mtx', false)
    local after_one = vim.fn.expand('%:t')
    assert(
      after_one ~= started_in,
      ('the keystroke should have switched buffers, still in %q'):format(after_one)
    )
    vim.api.nvim_feedkeys(tc, 'mtx', false)
    assert(
      vim.fn.expand('%:t') == started_in,
      'pressing it twice should return you to where you began'
    )
  end,
}
