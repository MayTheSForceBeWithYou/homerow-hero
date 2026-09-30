-- Drill 15. The lesson's sharpest point: "Neovim started" is a weaker claim than
-- "my config ran", because Neovim reports an error at step 8 and then carries on.
--
-- A config file sets a flag on its last line so you can tell the difference.
-- This drill simulates that. `setup()` runs a *partially failing* config: it
-- sets an early marker, then raises, so the final marker is never set.
--
-- Return the marker that proves the file ran to *completion*.
return {
  goal = 'Return the value that proves a config file ran all the way to the end',
  hint = 'Which of the two globals could only have been set if nothing raised?',
  check = function()
    -- A stand-in for a config that dies half way down.
    pcall(function()
      vim.g.hero_probe_started = true
      error('something broke in the middle of the file')
      vim.g.hero_probe_finished = true
    end)

    local answer = nil -- <- your answer: name the global that proves completion
    assert(answer ~= nil, 'DRILL_TODO')
    assert(
      answer == 'hero_probe_finished',
      ('expected the *last* marker set by the file, got %q'):format(tostring(answer))
    )
    -- And confirm you understand why: that global is nil, because it never ran.
    assert(
      vim.g[answer] == nil,
      'the completion marker should be unset here -- the file raised before reaching it'
    )
  end,
}
