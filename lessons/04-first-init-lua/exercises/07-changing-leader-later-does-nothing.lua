-- Drill 07. The consequence. Create a mapping while the leader is a comma, THEN
-- change the leader to a semicolon. Return true if the existing mapping keeps the
-- comma prefix.
--
-- If you expect changing `mapleader` to retrofit existing mappings, this drill is
-- the one to sit with.
return {
  goal = 'Return whether an existing mapping keeps its old leader after mapleader changes',
  check = function()
    pcall(vim.keymap.del, 'n', ',w')
    vim.g.mapleader = ','
    vim.keymap.set('n', '<leader>w', ':echo 1<CR>', { desc = 'drill 07' })
    vim.g.mapleader = ';'

    local stored
    for _, m in ipairs(vim.api.nvim_get_keymap('n')) do
      if m.desc == 'drill 07' then
        stored = m.lhs
      end
    end

    local answer = nil -- <- your answer
    assert(answer ~= nil, 'DRILL_TODO')
    assert(
      answer == (stored == ',w'),
      ('the mapping is on %q after the leader changed to ";"'):format(tostring(stored))
    )
  end,
}
