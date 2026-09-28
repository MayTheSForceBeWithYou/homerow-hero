-- Drill 21. Counts climb nesting for tags exactly as for brackets. From inside
-- the inner element, take the OUTER element's contents.
return {
  goal = "Delete the outer element's contents from inside the inner one",
  hint = 'Same mechanism as drill 13.',
  start = { '<a><b>x</b></a>' },
  cursor = { 1, 6 },
  want = { '<a></a>' },
  filetype = 'html',
  keys = '2dit',
}
