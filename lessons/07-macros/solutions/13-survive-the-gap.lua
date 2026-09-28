-- Drill 13. Sometimes a non-matching line should be skipped rather than treated as
-- a stopping point. `setup` wrote a substitution-based macro whose flag stops it
-- from failing; replay it three times and reach all three lines.
return {
  goal = 'Replay the substitution macro three times, visiting the non-matching line too',
  start = { 'a;b', 'no-semi', 'c;d' },
  cursor = { 1, 0 },
  want = { 'ab', 'no-semi', 'cd' },
  setup = function()
    -- The `e` flag makes a substitution succeed silently when nothing matches.
    vim.fn.setreg('s', ':s/;//e\rj')
  end,
  keys = '3@s',
}
