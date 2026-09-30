-- Drill 09. With 'hidden' off, leaving a modified buffer raises an error. Return the
-- error NUMBER, as a string like 'E99'.
--
-- The check reproduces it, so you can read the real message if you run the drill
-- before answering.
return {
  goal = "Return the error number raised when leaving a modified buffer with 'hidden' off",
  hint = 'The message ends with "(add ! to override)".',
  check = function()
    vim.cmd('silent! only')
    vim.cmd('edit! zz_mod.txt')
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'MODIFIED' })
    vim.bo.modified = true
    vim.o.hidden = false

    local answer = nil -- <- your answer
    assert(answer ~= nil, 'DRILL_TODO')

    local ok, err = pcall(vim.cmd, 'edit zz_other.txt')
    vim.o.hidden = true
    assert(not ok, "with 'hidden' off, leaving a modified buffer should fail")
    assert(
      tostring(err):find(answer, 1, true) ~= nil,
      ('the real error was %q, which does not contain %q'):format(tostring(err), answer)
    )
  end,
}
