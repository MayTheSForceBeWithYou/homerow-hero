-- Drill 10. The mode argument accepts a list. Map <F10> in both Normal and Visual
-- mode with one call.
return {
  goal = 'Map <F10> in Normal and Visual mode in a single call',
  check = function()
    pcall(vim.keymap.del, 'n', '<F10>')
    pcall(vim.keymap.del, 'v', '<F10>')

    error('DRILL_TODO') -- delete this line once you have written your answer

    -- <- your answer: write this line

    local function has(mode)
      for _, m in ipairs(vim.api.nvim_get_keymap(mode)) do
        if m.desc == 'drill 10' then
          return true
        end
      end
      return false
    end
    assert(has('n'), 'missing in Normal mode')
    assert(has('v'), 'missing in Visual mode')
  end,
}
