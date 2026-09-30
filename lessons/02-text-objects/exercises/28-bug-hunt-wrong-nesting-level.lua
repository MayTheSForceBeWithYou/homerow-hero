-- Drill 28. BUG HUNT -- starts FAILING.
--
-- The intent is to empty the OUTER brace block, from a cursor that sits inside the
-- inner one. The author navigated to a brace with `f{` first and then used the
-- object -- which moved the cursor into the inner block and targeted that instead.
--
-- Remove the navigation entirely and say how many levels out you want. The lesson
-- names the tool for this.
return {
  goal = 'Empty the outer brace block from a cursor inside the inner one',
  hint = 'Do not aim. The count selects the nesting level.',
  start = { 'opts = { inner = { a = 1 } }' },
  cursor = { 1, 20 },
  want = { 'opts = {}' },
  keys = 'f{di{',
}
