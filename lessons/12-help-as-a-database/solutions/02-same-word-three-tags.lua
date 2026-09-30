-- Drill 02. The reason people think the help is bad. `list` is at least three
-- different tags, and the check resolves each one to prove they are different pages.
--
-- Return the three tags as a list, in this order: the data type, the option, the Ex
-- command.
return {
  goal = 'Return the three "list" tags: data type, option, Ex command',
  hint = 'One is bare, one is quoted, one has a leading colon.',
  check = function()
    -- ANSWER_BEGIN
    local answer = { 'list', "'list'", ':list' }
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(#answer == 3, 'expected exactly three tags')

    local function resolve(tag)
      -- No fnameescape here: it escapes the quotes in "'list'" and the tag stops
      -- resolving. A help tag is not a filename.
      local ok = pcall(vim.cmd, 'help ' .. tag)
      local file = ok and vim.fn.expand('%:t') or nil
      if ok then
        pcall(vim.cmd, 'helpclose')
      end
      return file
    end

    local files = {}
    for i, tag in ipairs(answer) do
      local f = resolve(tag)
      assert(f, ('tag %q does not resolve to any help page'):format(tag))
      files[i] = f
    end
    assert(
      files[1] == 'vimeval.txt',
      ('the bare tag should reach vimeval.txt, reached %s'):format(files[1])
    )
    assert(
      files[2] == 'options.txt',
      ('the option tag should reach options.txt, reached %s'):format(files[2])
    )
    assert(
      files[3] == 'various.txt',
      ('the Ex command tag should reach various.txt, reached %s'):format(files[3])
    )
  end,
}
