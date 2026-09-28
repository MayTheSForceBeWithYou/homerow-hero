local function homerow_hero_lua_nav()
  vim.g.homerow_hero_navigation_lua_calls = (
    vim.g.homerow_hero_navigation_lua_calls or 0
  ) + 1
end

vim.keymap.set('n', '<leader>hh', homerow_hero_lua_nav, {
  desc = 'homerow hero lua keymap to function',
})

vim.g.homerow_hero_navigation_loaded = true
