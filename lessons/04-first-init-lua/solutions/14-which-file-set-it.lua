-- Drill 14. The command that ends arguments about which plugin overrode your
-- setting. Return the prefix you put in front of `set shiftwidth?` to be told the
-- file that last set it -- just the prefix word, no colon.
return {
  goal = 'Return the prefix that makes an option query report the file that set it',
  run = function()
    return 'verbose' -- <- your answer
  end,
  value = 'verbose',
}
