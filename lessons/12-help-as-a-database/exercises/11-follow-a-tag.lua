-- Drill 11. A |tag| reference in help text is a hyperlink. Put the cursor on one and
-- follow it, then come back -- and return true if you ended up where you started.
--
-- Note which key comes back: the TAG stack, not the jumplist.
return {
  goal = 'Follow a tag reference and return via the tag stack, ending where you began',
  hint = 'Two control keystrokes. The cursor must be on the tag text, not the bars.',
  check = function()
    vim.cmd('silent! only')
    vim.cmd('help vim.keymap.set()')
    vim.fn.search('|\\S\\+|', 'W')
    vim.fn.search('|\\zs\\S\\+\\ze|', 'c')
    local before = vim.fn.expand('%:t') .. ':' .. vim.api.nvim_win_get_cursor(0)[1]

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    local function feed(k)
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(k, true, false, true), 'mtx', false)
    end
    feed(answer[1])
    local after = vim.fn.expand('%:t') .. ':' .. vim.api.nvim_win_get_cursor(0)[1]
    assert(
      after ~= before,
      ('the first key should have followed the tag, still at %s'):format(after)
    )
    feed(answer[2])
    local returned = vim.fn.expand('%:t') .. ':' .. vim.api.nvim_win_get_cursor(0)[1]
    assert(
      returned == before,
      ('the second key should have returned to %s, landed at %s'):format(before, returned)
    )
    pcall(vim.cmd, 'helpclose')
  end,
}
