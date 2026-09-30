-- Drill 08. `vim.keymap.set` is the Lua equivalent of :nnoremap, not :nmap. That
-- is why a `*` appears beside it in a `:nmap` listing.
--
-- Return the value of the `noremap` field Neovim reports for a mapping created
-- with no `remap` option -- it is a number, not a boolean.
return {
  goal = 'Return the noremap value for a mapping created without a remap option',
  hint = 'Vimscript-facing fields answer with 1 and 0.',
  check = function()
    pcall(vim.keymap.del, 'n', '<F8>')
    vim.keymap.set('n', '<F8>', ':echo 1<CR>', { desc = 'drill 08' })

    local answer = 1 -- <- your answer
    assert(answer ~= nil, 'DRILL_TODO')

    local found
    for _, m in ipairs(vim.api.nvim_get_keymap('n')) do
      if m.desc == 'drill 08' then
        found = m
      end
    end
    assert(found, 'the mapping was not created')
    assert(
      found.noremap == answer,
      ('noremap is %s; you said %s'):format(tostring(found.noremap), tostring(answer))
    )
  end,
}
