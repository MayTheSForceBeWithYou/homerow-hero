-- Drill 14. The reason to prefer :argdo for a project-wide edit. Three buffers are
-- loaded; only two are arguments. Run a substitution over the arglist and confirm the
-- third buffer is untouched.
return {
  goal = 'Run a substitution with :argdo and leave the non-argument buffer unchanged',
  hint = 'Add the e flag so a file with no match does not abort the run.',
  check = function()
    vim.cmd('silent! only')
    vim.o.hidden = true
    local function seed(name)
      vim.cmd('edit! ' .. name)
      vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'target here' })
      vim.bo.modified = false
      return vim.api.nvim_get_current_buf()
    end
    local a, b, c = seed('zz_ad1.txt'), seed('zz_ad2.txt'), seed('zz_ad3.txt')
    vim.cmd('args zz_ad1.txt zz_ad3.txt')

    -- TODO_GUARD

    vim.cmd('silent argdo %s/target/CHANGED/ge') -- <- your answer

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
