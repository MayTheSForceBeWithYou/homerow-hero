return {
  goal = 'Rename across the declared argument files only, leaving the read-only buffer alone',
  hint = 'One of the :*do commands iterates what you chose; the other iterates whatever you happen to have open.',
  check = function()
    vim.cmd('silent! only')
    vim.o.hidden = true
    local function seed(name)
      vim.cmd('edit! ' .. name)
      vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'target here' })
      vim.bo.modified = false
      return vim.api.nvim_get_current_buf()
    end
    local a, b, c = seed('zz_bh1.txt'), seed('zz_bh2.txt'), seed('zz_bh3.txt')
    vim.cmd('args zz_bh1.txt zz_bh3.txt')

    -- `:bufdo` iterates every LISTED buffer -- including the one opened only to read,
    -- which is exactly the file a project-wide substitution must not touch. `:argdo`
    -- iterates the set declared with `:args`, so the file list is an inspectable
    -- decision rather than a consequence of what you happened to open.
    vim.cmd('silent argdo %s/target/CHANGED/ge')

    local function first(buf)
      return vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1]
    end
    assert(first(a):find('CHANGED'), ('arg 1 should have changed, is %q'):format(first(a)))
    assert(first(c):find('CHANGED'), ('arg 2 should have changed, is %q'):format(first(c)))
    assert(
      first(b) == 'target here',
      ('the non-argument buffer must be untouched, is %q'):format(first(b))
    )
    for _, buf in ipairs({ a, b, c }) do
      vim.bo[buf].modified = false
    end
  end,
}
