-- Drill 01. Set a boolean option from Lua, then let the check read it back.
-- Write the assignment on the marked line.
return {
  goal = 'Turn on line numbers by setting the option from Lua',
  hint = 'One table, one field, one boolean.',
  check = function()
    vim.o.number = false -- start from a known state

    error('DRILL_TODO') -- delete this line once you have written your answer

    -- <- your answer: write this line

    assert(vim.o.number == true, 'line numbers are still off')
  end,
}
