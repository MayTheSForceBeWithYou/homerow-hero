-- Drill 11. The payoff. Run a substitution over every quickfix entry and write the
-- files, then confirm all three were changed.
--
-- Two pieces carried over: the `e` flag from lesson 08 so a non-matching entry does not
-- abort the run, and `update` from lesson 10 so untouched files keep their timestamps.
return {
  goal = 'Replace NEEDLE with FOUND at every quickfix entry and write the files',
  hint = ':cdo takes a command. Pipe a write after it.',
  check = function()
    local dir = vim.fn.tempname()
    vim.fn.mkdir(dir .. '/sub', 'p')
    vim.fn.writefile({ 'alpha NEEDLE one', 'beta two', 'gamma NEEDLE three' }, dir .. '/a.txt')
    vim.fn.writefile({ 'delta four', 'epsilon NEEDLE five' }, dir .. '/b.txt')
    vim.fn.writefile({ 'zeta NEEDLE six' }, dir .. '/sub/c.txt')
    vim.cmd('silent! only')
    vim.o.hidden = true
    vim.cmd('cd ' .. vim.fn.fnameescape(dir))
    vim.fn.setqflist({})
    vim.cmd('silent vimgrep /NEEDLE/j **/*.txt')

    -- TODO_GUARD

    vim.cmd('silent cdo s/NEEDLE/FOUND/e | update') -- <- your answer

    for _, f in ipairs({ 'a.txt', 'b.txt', 'sub/c.txt' }) do
      local text = table.concat(vim.fn.readfile(dir .. '/' .. f), '\n')
      assert(not text:find('NEEDLE'), ('%s still contains NEEDLE: %q'):format(f, text))
      assert(text:find('FOUND'), ('%s was not changed: %q'):format(f, text))
    end
  end,
}
