-- Drill 03. Two layouts answer to the same require name. Build the DIRECTORY form --
-- a package whose entry point is init.lua -- and require it by the bare name.
return {
  goal = 'Create a module as a directory with init.lua and require it by the bare name',
  hint = 'lua/<name>/init.lua',
  check = function()
    local dir = vim.fn.tempname()
    package.loaded['d03pkg'] = nil

    -- ANSWER_BEGIN
    local relative_path = 'lua/d03pkg/init.lua'
    -- ANSWER_END

    assert(relative_path ~= nil, 'DRILL_TODO')
    vim.fn.mkdir(dir .. '/' .. vim.fn.fnamemodify(relative_path, ':h'), 'p')
    vim.fn.writefile({ "return { where = 'directory form' }" }, dir .. '/' .. relative_path)
    vim.opt.runtimepath:prepend(dir)

    local ok, mod = pcall(require, 'd03pkg')
    assert(ok, ('require("d03pkg") failed: %s'):format(tostring(mod)))
    assert(mod.where == 'directory form', 'the directory form should resolve by the bare name')
  end,
}
