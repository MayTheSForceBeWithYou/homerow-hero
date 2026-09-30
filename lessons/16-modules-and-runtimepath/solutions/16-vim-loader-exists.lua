-- Drill 16. Neovim ships a second cache -- compiled bytecode -- which is a second suspect
-- when a change is not taking effect. Return a list of the two function names on it that
-- this lesson names: the one that turns it on and the one that clears it.
return {
  goal = 'Return the enable and reset function names on the module cache',
  hint = 'vim.loader',
  check = function()
    -- ANSWER_BEGIN
    local answer = { 'enable', 'reset' }
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(#answer == 2, 'expected two names')
    for _, name in ipairs(answer) do
      assert(
        type(vim.loader[name]) == 'function',
        ('vim.loader.%s is not a function'):format(tostring(name))
      )
    end
  end,
}
