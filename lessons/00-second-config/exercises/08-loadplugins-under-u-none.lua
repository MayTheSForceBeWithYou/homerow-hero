-- Drill 08. This drill runner starts Neovim with `-u NONE`. The lesson measured
-- what that does to plugin loading, and the table says how `-u NONE` differs
-- from `--clean` and `-u NORC` on exactly this point.
--
-- Return the value of the 'loadplugins' option in this session.
return {
  goal = "Return the value of 'loadplugins' in a `-u NONE` session",
  hint = 'Read it from the option, do not type the literal -- then check it against the table.',
  run = function()
    return nil -- <- your answer
  end,
  value = false,
}
