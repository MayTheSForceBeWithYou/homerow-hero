return {
  goal = 'Return the flag that also drops your user directories from the runtimepath',
  run = function()
    -- `-u NORC` leaves ~/.config/nvim and ~/.local/share/nvim/site *searchable*,
    -- so a :runtime or colorscheme lookup can still reach your files.
    return '--clean'
  end,
  value = '--clean',
}
