-- Drill 14. The distinction that produces misleading bisects. `--clean` and
-- `-u NORC` both skip your config and both keep plugins enabled -- but they do
-- not agree about the runtimepath.
--
-- Return the name of the flag (exactly as typed on the command line) that also
-- removes your own config and site directories from the runtimepath.
return {
  goal = 'Return the flag that also drops your user directories from the runtimepath',
  run = function()
    return nil -- <- your answer
  end,
  value = '--clean',
}
