-- Drill 12. There is one quickfix list for the session and one location list per
-- window. Fill both with different searches and return their sizes as
-- { quickfix_count, loclist_count }.
return {
  goal = "Return the quickfix count and this window's location-list count",
  hint = 'The location-list functions take a window argument; 0 means the current one.',
  check = function()
    local dir = vim.fn.tempname()
    vim.fn.mkdir(dir, 'p')
    vim.fn.writefile({ 'alpha NEEDLE one', 'beta', 'gamma NEEDLE three' }, dir .. '/a.txt')
    vim.fn.writefile({ 'delta', 'epsilon NEEDLE five' }, dir .. '/b.txt')
    vim.cmd('silent! only')
    vim.o.hidden = true
    vim.cmd('cd ' .. vim.fn.fnameescape(dir))
    vim.fn.setqflist({})
    vim.fn.setloclist(0, {})
    vim.cmd('silent vimgrep /NEEDLE/j *.txt') -- 3 entries, global
    vim.cmd('silent lvimgrep /NEEDLE/j a.txt') -- 2 entries, this window only

    -- ANSWER_BEGIN
    local answer = { #vim.fn.getqflist(), #vim.fn.getloclist(0) }
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer[1] == 3, ('quickfix should hold 3, got %s'):format(tostring(answer[1])))
    assert(answer[2] == 2, ('the location list should hold 2, got %s'):format(tostring(answer[2])))
    assert(answer[1] ~= answer[2], 'the two lists are separate things holding different results')
  end,
}
