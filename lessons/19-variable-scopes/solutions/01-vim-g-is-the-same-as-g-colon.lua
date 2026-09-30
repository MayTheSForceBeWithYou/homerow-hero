-- Drill 01. `vim.g` and Vimscript's `g:` are the same storage, not parallel systems. Set a
-- variable from Lua and return what Vimscript sees.
return {
  goal = 'Set a global from Lua and read it back through Vimscript',
  hint = 'nvim_exec2 with output = true captures an :echo.',
  check = function()
    vim.g.hero_d01 = 'from lua'

    -- ANSWER_BEGIN
    local answer = vim.trim(vim.api.nvim_exec2('echo g:hero_d01', { output = true }).output)
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == 'from lua', ('Vimscript saw %q'):format(tostring(answer)))
    vim.g.hero_d01 = nil
  end,
}
