-- Drill 22. A count applies to the motion's *search*, not to the operator:
-- `d2fo` deletes through the second `o`, not through the first one twice.
return {
  goal = 'Delete through the second "o" on the line',
  start = { 'the quick brown fox' },
  cursor = { 1, 0 },
  want = { 'x' },
  keys = 'd2fo',
}
