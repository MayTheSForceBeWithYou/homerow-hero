-- Drill 05. Create the keymap from the lesson. The check reads it back out of
-- Neovim rather than pressing it, which is the habit the lesson argues for.
return {
  goal = 'Map <leader>n in Normal mode to clear the search highlight, with a description',
  hint = 'Four arguments: mode, lhs, rhs, opts. The rhs needs <CR>.',
  check = function()
    vim.g.mapleader = ' '
    pcall(vim.keymap.del, 'n', '<leader>n')

    error('DRILL_TODO') -- delete this line once you have written your answer

    -- <- your answer: write this line

    local found
    for _, m in ipairs(vim.api.nvim_get_keymap('n')) do
      if m.lhs == ' n' then
        found = m
      end
    end
    assert(found, 'no Normal-mode mapping on <Space>n -- check the lhs and the leader')
    assert(
      found.rhs and found.rhs:find('nohlsearch', 1, true),
      ('rhs is %q'):format(tostring(found.rhs))
    )
    assert(found.rhs:find('<CR>', 1, true) or found.rhs:find('\r', 1, true), 'the rhs needs <CR>')
    assert(found.desc and found.desc ~= '', 'every mapping should carry a desc')
  end,
}
