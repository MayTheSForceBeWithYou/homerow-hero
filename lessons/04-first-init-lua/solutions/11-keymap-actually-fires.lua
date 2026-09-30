-- Drill 11. Now press it. `setup` installs a mapping that uppercases the word
-- under the cursor; type the key that triggers it.
--
-- The drill runner feeds keys with mappings enabled, so this works exactly as it
-- would if you had typed it in a real Neovim.
return {
  goal = 'Trigger the mapping installed by setup',
  hint = 'The leader is set to a comma in setup.',
  start = { 'make this loud' },
  cursor = { 1, 5 },
  want = { 'make THIS loud' },
  setup = function()
    vim.g.mapleader = ','
    vim.keymap.set('n', '<leader>u', 'gUiw', { desc = 'drill 11 uppercase word' })
  end,
  keys = ',u',
}
