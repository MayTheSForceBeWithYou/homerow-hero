-- Drill 21. The slash is only a delimiter. Replacing a path is much easier with a
-- different one -- no escaping required.
return {
  goal = 'Replace /usr/local with /opt without escaping any slashes',
  hint = 'Any non-alphanumeric character can delimit a substitution.',
  start = { 'prefix=/usr/local/bin' },
  cursor = { 1, 0 },
  want = { 'prefix=/opt/bin' },
  keys = ':s#/usr/local#/opt#<CR>',
}
