-- Drill 15. The environment table is live and writable, which is how you set a variable for
-- a child process without touching your shell.
--
-- Set one and return what Vimscript's $NAME expansion sees.
return {
  goal = 'Set an environment variable from Lua and read it back through Ex',
  check = function()
    -- ANSWER_BEGIN
    vim.env.HERO_D15 = 'set-from-lua'
    local answer = vim.trim(vim.api.nvim_exec2('echo $HERO_D15', { output = true }).output)
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == 'set-from-lua', ('Ex saw %q'):format(tostring(answer)))
    assert(vim.fn.getenv('HERO_D15') == 'set-from-lua', 'and getenv agrees')
  end,
}
