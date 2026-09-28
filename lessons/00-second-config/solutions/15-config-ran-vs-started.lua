return {
  goal = 'Return the value that proves a config file ran all the way to the end',
  hint = 'Which of the two globals could only have been set if nothing raised?',
  check = function()
    pcall(function()
      vim.g.hero_probe_started = true
      error('something broke in the middle of the file')
      vim.g.hero_probe_finished = true
    end)

    -- `hero_probe_started` proves only that Neovim reached the file's first line.
    -- Only a marker on the *last* line distinguishes "ran" from "started".
    local answer = 'hero_probe_finished'
    assert(answer ~= nil, 'DRILL_TODO')
    assert(
      answer == 'hero_probe_finished',
      ('expected the *last* marker set by the file, got %q'):format(tostring(answer))
    )
    assert(
      vim.g[answer] == nil,
      'the completion marker should be unset here -- the file raised before reaching it'
    )
  end,
}
