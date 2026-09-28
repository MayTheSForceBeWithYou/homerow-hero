-- Drill 16. Lowercase marks are per-buffer, so jumping to one that was never set
-- here is an error. Return the error number Neovim gives, as a string like 'E99'.
--
-- Produce it rather than remembering it: the check below runs your answer against
-- a real failure.
return {
  goal = 'Return the error number for jumping to a mark that was never set',
  hint = "pcall(vim.cmd, 'normal! `z') will show you.",
  check = function()
    vim.cmd('enew!')
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'a', 'b' })

    local answer = nil -- <- your answer
    assert(answer ~= nil, 'DRILL_TODO')

    local ok, err = pcall(vim.cmd, 'normal! `z')
    assert(not ok, 'expected jumping to an unset mark to fail')
    assert(
      tostring(err):find(answer, 1, true) ~= nil,
      ('the real error was %q, which does not contain %q'):format(tostring(err), answer)
    )
  end,
}
