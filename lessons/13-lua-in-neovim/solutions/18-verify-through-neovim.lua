-- Drill 18. The rule for the rest of the course. Return the shell command that runs a
-- Lua snippet the way your CONFIG will see it -- not the way a shell REPL would.
--
-- Use exactly this shape, with SNIPPET where the code goes:
--   nvim --headless -u NONE -c 'lua SNIPPET' -c qa
return {
  goal = 'Return the shell command that verifies a Lua idiom through Neovim',
  hint = 'It is not lua -e.',
  run = function()
    return "nvim --headless -u NONE -c 'lua SNIPPET' -c qa" -- <- your answer
  end,
  value = "nvim --headless -u NONE -c 'lua SNIPPET' -c qa",
}
