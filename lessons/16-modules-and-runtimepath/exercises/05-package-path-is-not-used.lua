-- Drill 05. The misleading part. A fixture on the runtimepath is findable by require --
-- and its directory appears nowhere in package.path.
--
-- Return the number of package.path entries that mention the fixture directory.
return {
  goal = 'Return how many package.path entries mention a runtimepath fixture directory',
  hint = 'Split package.path on semicolons and count the matches.',
  check = function()
    local dir = vim.fn.tempname()
    vim.fn.mkdir(dir .. '/lua', 'p')
    vim.fn.writefile({ 'return { ok = true }' }, dir .. '/lua/d05mod.lua')
    vim.opt.runtimepath:prepend(dir)
    package.loaded['d05mod'] = nil
    assert(pcall(require, 'd05mod'), 'sanity: the module should be findable')

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(
      answer == 0,
      ('package.path should not mention it at all, you said %s'):format(tostring(answer))
    )
  end,
}
