-- Drill 22. BUG HUNT -- starts FAILING.
--
-- The intent is to return to the most recent EDIT. Two lines were changed, then we
-- jumped to the end of the file to check something, then to the top. We want to
-- land back on line 5, where the latest change is.
--
-- The author reached for the back-button. Run it: you end up on line 6 -- the place
-- the most recent *jump* started from, which has nothing to do with the edits.
--
-- Note that this bug hides itself. Remove the `G` and the wrong answer lands on
-- line 5 by coincidence, because there the last jump happened to start where the
-- last edit was. Ask which history actually records edits.
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
  keys = '2GA!<Esc>5GA?<Esc>Ggg<C-o>',
}
