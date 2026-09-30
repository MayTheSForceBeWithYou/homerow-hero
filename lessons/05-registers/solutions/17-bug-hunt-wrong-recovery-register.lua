return {
  goal = 'After yanking line 1 and deleting line 2, put the yanked line',
  hint = 'Deletes queue in the numbered registers. Which register do they never touch?',
  start = { 'KEEP', 'GONE', 'tail' },
  cursor = { 1, 0 },
  want = { 'KEEP', 'tail', 'KEEP' },
  -- `"1` is where the linewise DELETE went, so putting from it reproduces exactly
  -- the bug being worked around. `"0` holds the most recent yank and no delete
  -- ever writes to it.
  keys = 'yyjdd"0p',
}
