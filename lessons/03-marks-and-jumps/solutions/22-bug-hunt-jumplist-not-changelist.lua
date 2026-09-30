return {
  goal = 'After two edits and a look at the end of the file, return to the most recent edit',
  hint = 'The jumplist records where you looked. A different list records where you changed.',
  start = { 'l1', 'l2', 'l3', 'l4', 'l5', 'l6' },
  cursor = { 1, 0 },
  want = { 'l1', 'l2!', 'l3', 'l4', 'l5?', 'l6' },
  want_cursor = { 5, 2 },
  setup = function()
    vim.cmd('clearjumps')
  end,
  -- `<C-o>` walked the jumplist, whose newest entry is line 6 -- where the `gg`
  -- jump started. The edits are not in that list at all. `g;` walks the changelist,
  -- whose newest entry is the change on line 5.
  keys = '2GA!<Esc>5GA?<Esc>Gggg;',
}
