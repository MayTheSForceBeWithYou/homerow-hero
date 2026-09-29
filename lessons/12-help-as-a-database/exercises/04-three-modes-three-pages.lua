-- Drill 04. Prove it. Return the three tags for CTRL-W in Normal, Insert and
-- Command-line mode, in that order, and the check confirms each lands somewhere
-- different.
return {
  goal = 'Return the CTRL-W tags for Normal, Insert and Command-line mode',
  check = function()
    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    local seen = {}
    for _, tag in ipairs(answer) do
      local ok = pcall(vim.cmd, 'help ' .. tag)
      assert(ok, ('tag %q does not resolve'):format(tag))
      table.insert(seen, vim.fn.expand('%:t'))
      pcall(vim.cmd, 'helpclose')
    end
    assert(seen[1] ~= seen[2], 'Normal and Insert mode should be documented in different files')
    assert(
      seen[2] ~= seen[3],
      'Insert and Command-line mode should be documented in different files'
    )
    assert(seen[2] == 'insert.txt', ('Insert mode should be in insert.txt, got %s'):format(seen[2]))
    assert(
      seen[3] == 'cmdline.txt',
      ('Command-line mode should be in cmdline.txt, got %s'):format(seen[3])
    )
  end,
}
