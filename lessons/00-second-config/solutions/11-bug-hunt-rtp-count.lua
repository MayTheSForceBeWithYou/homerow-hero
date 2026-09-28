return {
  goal = 'Count the number of directories on the runtimepath',
  hint = '`#` on a string counts characters. What type is vim.o.runtimepath?',
  check = function()
    -- 'runtimepath' is a single comma-separated *string*, so `#` on it counted
    -- characters (299 on the author's machine). Split it into a list first.
    local count = #vim.split(vim.o.runtimepath, ',')

    assert(type(count) == 'number', 'count should be a number')

    local _, commas = vim.o.runtimepath:gsub(',', '')
    assert(
      count == commas + 1,
      ('the runtimepath holds %d commas, so it has %d entries -- you reported %d'):format(
        commas,
        commas + 1,
        count
      )
    )
  end,
}
