-- Drill 07. `:b` takes a unique substring of the name, so you never need to look up a
-- number. Switch to the buffer whose name contains "alpha" without using its number.
return {
  goal = 'Switch to the buffer whose name contains "alpha" using a substring',
  hint = 'The command is :buffer, and its argument need not be a number.',
  check = function()
    vim.cmd('silent! only')
    for _, name in ipairs({ 'zz_alpha.txt', 'zz_beta.txt' }) do
      vim.cmd('edit ' .. name)
    end
    assert(vim.fn.expand('%:t') == 'zz_beta.txt', 'setup should have left us in beta')

    -- TODO_GUARD

    vim.cmd('buffer alpha') -- <- your answer

    assert(
      vim.fn.expand('%:t') == 'zz_alpha.txt',
      ('expected to land in zz_alpha.txt, got %q'):format(vim.fn.expand('%:t'))
    )
  end,
}
