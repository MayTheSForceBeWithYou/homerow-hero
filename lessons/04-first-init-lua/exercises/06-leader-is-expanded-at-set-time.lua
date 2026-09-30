-- Drill 06. The fact that costs people an evening. Set the leader to a comma,
-- create a mapping written as `<leader>q`, then return the lhs that Neovim
-- actually stored.
--
-- Return it as a literal string -- what you would see in the `:nmap` listing.
return {
  goal = 'Return the lhs Neovim stores for <leader>q when mapleader is a comma',
  hint = 'The mapping does not store "leader then q".',
  check = function()
    vim.g.mapleader = ','
    pcall(vim.keymap.del, 'n', '<leader>q')
    vim.keymap.set('n', '<leader>q', ':echo 1<CR>', { desc = 'drill 06' })

    local answer = nil -- <- your answer
    assert(answer ~= nil, 'DRILL_TODO')

    local stored
    for _, m in ipairs(vim.api.nvim_get_keymap('n')) do
      if m.desc == 'drill 06' then
        stored = m.lhs
      end
    end
    assert(stored, 'the mapping was not created')
    assert(stored == answer, ('Neovim stored %q; you said %q'):format(stored, answer))
  end,
}
