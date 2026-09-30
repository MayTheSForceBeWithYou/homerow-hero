return {
  goal = 'Set a per-buffer indent without changing what later buffers inherit',
  hint = 'Which table is equivalent to :set, and which to :setlocal?',
  check = function()
    local lua_buf = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_set_current_buf(lua_buf)
    vim.api.nvim_set_option_value('shiftwidth', 8, { scope = 'global' })
    vim.api.nvim_set_option_value('shiftwidth', 8, { buf = lua_buf })

    -- `vim.o` behaves like `:set` -- it writes the global default too, and a new buffer
    -- inherits the global. `vim.bo` writes only this buffer, which is what a per-filetype
    -- setting means.
    vim.bo.shiftwidth = 2

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
