-- Drill 05. Tab-page variables belong to a layout. Set one in the first tab, open a second,
-- and report both what the new tab sees and what the original still holds.
--
-- Return a list of two booleans:
--   { the_new_tab_saw_nothing, the_original_kept_its_value }
return {
  goal = 'Return whether a new tab starts clean and the original keeps its tab variable',
  hint = 'Check the new tab, then go back and check the first one.',
  check = function()
    vim.cmd('silent! tabonly')
    vim.t.hero_d05 = 'tab1'
    vim.cmd('tabnew')
    local in_new_tab = vim.t.hero_d05
    vim.cmd('tabclose')
    local back_in_first = vim.t.hero_d05

    -- ANSWER_BEGIN
    local answer = { in_new_tab == nil, back_in_first == 'tab1' }
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(type(answer) == 'table' and #answer == 2, 'expected a list of two booleans')
    assert(answer[1] == true, 'a new tab page starts with no value for the variable')
    assert(answer[2] == true, 'and the original tab kept its own')
    vim.t.hero_d05 = nil
  end,
}
