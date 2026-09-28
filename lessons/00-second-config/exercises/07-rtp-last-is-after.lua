-- Drill 07. The other half of the rule: the runtimepath is a palindrome around
-- Neovim's own runtime, so the *last* entry is an `after/` directory -- which is
-- why a file in `after/` overrides the same file from a plugin.
--
-- Return true if the last runtimepath entry ends in '/after'.
return {
  goal = "Return whether the last runtimepath entry ends in '/after'",
  hint = 'In Lua, `t[#t]` is the last element of list `t`.',
  run = function()
    return nil -- <- your answer
  end,
  value = true,
}
