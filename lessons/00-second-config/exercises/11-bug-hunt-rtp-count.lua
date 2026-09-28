-- Drill 11. BUG HUNT -- this one starts FAILING. Do not rewrite it from scratch;
-- find the single wrong assumption on the marked line.
--
-- The intent is to count how many directories are on the runtimepath. The
-- lesson's listing showed twelve of them. This code reports a number in the
-- hundreds.
--
-- Ask what `#` is measuring, and what `vim.o.runtimepath` actually *is*. The
-- lesson says it in one sentence.
return {
  goal = 'Count the number of directories on the runtimepath',
  hint = '`#` on a string counts characters. What type is vim.o.runtimepath?',
  check = function()
    local count = #vim.o.runtimepath -- <- BUG IS ON THIS LINE

    assert(type(count) == 'number', 'count should be a number')

    -- Derived independently of how you counted, so this works on any machine:
    -- a list of N entries joined by commas contains N-1 commas.
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
