return {
  goal = 'Insert "# " at column 1, before the indentation',
  hint = 'One of the pair respects indentation. You want the one that does not.',
  start = { '    local x = 1' },
  cursor = { 1, 10 },
  want = { '#     local x = 1' },
  -- `I` enters before the first NON-BLANK, so it lands inside the indentation.
  -- `gI` enters at column 1 and ignores indentation entirely.
  keys = 'gI# <Esc>',
}
