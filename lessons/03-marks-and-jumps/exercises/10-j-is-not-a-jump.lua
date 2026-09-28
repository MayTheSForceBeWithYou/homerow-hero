-- Drill 10. Prove the distinction rather than taking the lesson's word for it.
-- Move down five lines with a plain movement, then count the jumplist.
--
-- Return the number of jumplist entries afterwards. If `j` were a jump, <C-o>
-- would walk you back one line at a time and be useless.
return {
  goal = 'Return how many jumplist entries a plain downward movement creates',
  hint = 'Read the documented list of jump commands. Is j on it?',
  check = function()
    vim.cmd('enew!')
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'a', 'b', 'c', 'd', 'e', 'f', 'g' })
    vim.cmd('clearjumps')
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
    vim.api.nvim_feedkeys('5j', 'mtx', false)

    local function entries()
      local n = 0
      for line in vim.api.nvim_exec2('jumps', { output = true }).output:gmatch('[^\n]+') do
        if line:match('^%s*%d+%s+%d+') then
          n = n + 1
        end
      end
      return n
    end

    local answer = nil -- <- your answer
    assert(answer ~= nil, 'DRILL_TODO')
    assert(
      answer == entries(),
      ('the jumplist actually holds %d entries after 5j; you said %d'):format(entries(), answer)
    )
    assert(vim.api.nvim_win_get_cursor(0)[1] == 6, 'the movement itself should have reached line 6')
  end,
}
