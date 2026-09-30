-- Drill 04. `require` finds a module through the RUNTIMEPATH, not through package.path.
-- Put a fixture on the runtimepath and confirm the module loads from it.
--
-- Return the name of the option that makes this work.
return {
  goal = 'Return the option name whose lua/ directories require searches',
  hint = 'Lesson 00 drew it as a palindrome.',
  check = function()
    local answer = 'runtimepath' -- <- your answer
    assert(answer ~= nil, 'DRILL_TODO')

    local dir = vim.fn.tempname()
    vim.fn.mkdir(dir .. '/lua', 'p')
    vim.fn.writefile({ 'return { ok = true }' }, dir .. '/lua/d04mod.lua')
    package.loaded['d04mod'] = nil

    -- Prepending to the option the learner named must make the module findable.
    local opt = vim.opt[answer]
    assert(opt ~= nil, ('%q is not an option'):format(answer))
    opt:prepend(dir)

    local ok, mod = pcall(require, 'd04mod')
    assert(ok, ('the module was still not found after prepending to %q'):format(answer))
    assert(mod.ok == true)
  end,
}
