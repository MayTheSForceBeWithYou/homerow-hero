-- Drill 12. A string rhs means "type these keys", and typing `:nohlsearch` without
-- pressing Enter leaves the command sitting on the command line, unexecuted.
--
-- Return the rhs string that actually *runs* the command, written the way you
-- would put it in a config.
return {
  goal = 'Return the rhs string that executes :nohlsearch rather than merely typing it',
  hint = 'One notation for a key is missing from the wrong version.',
  run = function()
    return ':nohlsearch<CR>' -- <- your answer
  end,
  value = ':nohlsearch<CR>',
}
