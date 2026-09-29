-- Drill 14. `:grep` shells out to whatever 'grepprg' names. Neovim points it at
-- ripgrep only when ripgrep is installed, which is why the same command is not the
-- same command on two machines.
--
-- Return true if this Neovim's 'grepprg' mentions ripgrep, OR if ripgrep is absent
-- from PATH -- in other words, confirm the two agree with each other.
return {
  goal = "Return whether 'grepprg' and the presence of ripgrep agree",
  hint = 'vim.fn.executable() answers with 1 or 0.',
  check = function()
    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(
      answer == true,
      ("'grepprg' is %q while executable('rg') is %d -- these should agree"):format(
        vim.o.grepprg,
        vim.fn.executable('rg')
      )
    )
  end,
}
