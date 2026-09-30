return {
  goal = "Return whether the last runtimepath entry ends in '/after'",
  hint = 'In Lua, `t[#t]` is the last element of list `t`.',
  run = function()
    local entries = vim.split(vim.o.runtimepath, ',')
    -- `$` anchors the pattern to the end; match returns nil when it fails.
    return entries[#entries]:match('/after$') ~= nil
  end,
  value = true,
}
