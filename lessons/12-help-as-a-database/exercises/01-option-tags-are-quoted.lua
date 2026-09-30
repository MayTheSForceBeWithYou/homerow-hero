-- Drill 01. An option's tag includes its quotes. Return the tag you would type after
-- `:h` to reach the documentation for the shiftwidth OPTION -- including the quote
-- characters, exactly as typed.
return {
  goal = 'Return the help tag for the shiftwidth option',
  hint = 'Two characters more than the option name.',
  run = function()
    return nil -- <- your answer
  end,
  value = "'shiftwidth'",
}
