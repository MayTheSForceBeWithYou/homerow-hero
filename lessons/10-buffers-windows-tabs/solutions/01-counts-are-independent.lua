-- Drill 01. Buffers, windows and tab pages are three separate things with three
-- separate counts. Open two named buffers and make one split, then return the three
-- counts as a list: { buffers, windows, tabpages }.
--
-- The buffers are named rather than created with a bare `:enew` on purpose. `:h
-- windows.txt` notes that a new empty buffer which has not been modified gets REUSED
-- when the next file is loaded into it -- so two consecutive `:enew` calls leave you
-- with one buffer, not two.
return {
  goal = 'Return the counts of listed buffers, windows and tab pages as a list',
  hint = 'Three different API calls. Nothing forces the numbers to agree.',
  check = function()
    vim.cmd('silent! only')
    vim.o.hidden = true
    vim.cmd('edit zz_count1.txt')
    vim.cmd('edit zz_count2.txt')
    vim.cmd('split')

    -- ANSWER_BEGIN
    local answer = {
      #vim.fn.getbufinfo({ buflisted = 1 }),
      #vim.api.nvim_list_wins(),
      #vim.api.nvim_list_tabpages(),
    }
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(
      answer[2] == 2,
      ('expected 2 windows after one split, got %s'):format(tostring(answer[2]))
    )
    assert(answer[3] == 1, ('expected 1 tab page, got %s'):format(tostring(answer[3])))
    assert(
      answer[1] >= 2,
      ('expected at least 2 listed buffers, got %s'):format(tostring(answer[1]))
    )
    -- The three counts genuinely disagree, which is the point of the drill.
    assert(answer[1] ~= answer[3], 'buffers and tab pages should not be the same number here')
    vim.cmd('silent! only')
  end,
}
