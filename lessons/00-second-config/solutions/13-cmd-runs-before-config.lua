return {
  goal = 'Return the command-line flag that runs a command before your config loads',
  run = function()
    -- `--cmd` runs at startup step 3; `-c` runs after step 8, so a `-c` command
    -- would be overwritten by anything the config sets.
    return '--cmd'
  end,
  value = '--cmd',
}
