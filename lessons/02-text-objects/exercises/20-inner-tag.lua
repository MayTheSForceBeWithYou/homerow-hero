-- Drill 20. Tag objects need the buffer's filetype set -- the drill sets
-- `filetype = 'html'` for you. Delete the element's contents.
return {
  goal = "Delete the paragraph's contents, keeping both tags",
  start = { '<p>hello</p>' },
  cursor = { 1, 5 },
  want = { '<p></p>' },
  filetype = 'html',
  keys = '', -- <- your answer
}
