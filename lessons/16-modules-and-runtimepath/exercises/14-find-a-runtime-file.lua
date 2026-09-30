-- Drill 14. The right way to answer "is my module where I think it is?" -- better than
-- reading the not-found error's path list, which is package.path and not where Neovim
-- looked.
--
-- Return the list of matches for a module file you have just created.
return {
  goal = 'Return the runtime-file matches for a module you created on the runtimepath',
  hint = 'An nvim_get_runtime_file call, asking for all matches.',
  check = function()
    local dir = vim.fn.tempname()
    vim.fn.mkdir(dir .. '/lua/d14ns', 'p')
    vim.fn.writefile({ 'return {}' }, dir .. '/lua/d14ns/thing.lua')
    vim.opt.runtimepath:prepend(dir)

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(type(answer) == 'table', 'expected a list of paths')
    assert(#answer >= 1, 'the file should have been found on the runtimepath')
    assert(answer[1]:find('thing.lua', 1, true), ('got %s'):format(vim.inspect(answer)))
  end,
}
