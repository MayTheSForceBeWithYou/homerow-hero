-- Drill 19. `C` is shorthand -- but write it as an operator plus a motion here,
-- because that is what this lesson is for.
return {
  goal = 'Replace everything from "brown" to the end of the line with "dog"',
  start = { 'the quick brown fox' },
  cursor = { 1, 10 },
  want = { 'the quick dog' },
  keys = 'c$dog<Esc>',
}
