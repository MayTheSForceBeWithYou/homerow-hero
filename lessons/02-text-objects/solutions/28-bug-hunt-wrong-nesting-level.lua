return {
  goal = 'Empty the outer brace block from a cursor inside the inner one',
  hint = 'Do not aim. The count selects the nesting level.',
  start = { 'opts = { inner = { a = 1 } }' },
  cursor = { 1, 20 },
  want = { 'opts = {}' },
  -- `f{` re-introduced the cursor dependence that objects exist to remove. A count
  -- climbs outward one nesting level per unit, from wherever the cursor already is.
  keys = '2di{',
}
