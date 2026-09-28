-- Drill 09. The opposite case, which is what a missing `*` in a listing means.
-- Create a mapping that IS remappable, then let the check confirm it.
return {
  goal = 'Create a remappable mapping on <F9>',
  hint = 'One extra field in the opts table.',
  check = function()
    pcall(vim.keymap.del, 'n', '<F9>')

    error('DRILL_TODO') -- delete this line once you have written your answer

    -- <- your answer: write this line

    local found
    for _, m in ipairs(vim.api.nvim_get_keymap('n')) do
      if m.desc == 'drill 09' then
        found = m
      end
    end
    assert(found, 'no mapping on <F9> with desc "drill 09"')
    assert(found.noremap == 0, 'this mapping is still non-recursive -- noremap is 1')
  end,
}
