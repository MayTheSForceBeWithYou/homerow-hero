-- Drill 19. BUG HUNT -- starts FAILING, and this is the option bug that is hardest to find
-- because the symptom appears in a DIFFERENT file from the cause.
--
-- The intent is a per-filetype indent: Lua files get two spaces, and nothing else changes.
-- Run it: the Lua buffer is correct, and a buffer created afterwards has inherited 2 as
-- well.
--
-- The table used writes both scopes. One of the five leaves the global default alone.
return {
  goal = 'Set a per-buffer indent without changing what later buffers inherit',
  hint = 'Which table is equivalent to :set, and which to :setlocal?',
  check = function()
    local lua_buf = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_set_current_buf(lua_buf)
    vim.api.nvim_set_option_value('shiftwidth', 8, { scope = 'global' })
    vim.api.nvim_set_option_value('shiftwidth', 8, { buf = lua_buf })

    vim.o.shiftwidth = 2

    local later = vim.api.nvim_create_buf(true, true)

    assert(vim.bo[lua_buf].shiftwidth == 2, 'the target buffer should be 2')
    assert(
      vim.bo[later].shiftwidth == 8,
      ('a buffer created afterwards inherited %d -- the global default was changed'):format(
        vim.bo[later].shiftwidth
      )
    )
  end,
}
