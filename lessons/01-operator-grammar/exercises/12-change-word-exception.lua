-- Drill 12. `cw` on a non-blank behaves as `ce` -- it does not swallow the
-- following space, even though `w` is exclusive. Change "the" to "THE" and note
-- that the space survives.
return {
  goal = 'Change "the" to "THE" with the change-word command',
  start = { 'the quick brown fox' },
  cursor = { 1, 0 },
  want = { 'THE quick brown fox' },
  keys = '', -- <- your answer
}
