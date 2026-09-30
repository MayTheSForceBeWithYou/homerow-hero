return {
  goal = "Return the value of 'loadplugins' in a `-u NONE` session",
  hint = 'Read it from the option, do not type the literal -- then check it against the table.',
  run = function()
    -- `-u NONE` disables plugin loading; `--clean` and `-u NORC` leave it on.
    return vim.o.loadplugins
  end,
  value = false,
}
