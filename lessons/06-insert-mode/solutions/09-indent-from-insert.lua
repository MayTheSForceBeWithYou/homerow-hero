-- Drill 09. Indent the current line from inside Insert mode. The drill runs under
-- `-u NONE`, where 'expandtab' is off, so one indent is a tab -- hence "\t" in
-- `want`.
return {
  goal = 'Indent the line by one level from inside Insert mode',
  start = { 'x' },
  cursor = { 1, 0 },
  want = { '\tZx' },
  keys = 'i<C-t>Z<Esc>',
}
