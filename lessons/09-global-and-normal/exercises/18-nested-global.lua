-- Drill 18. "Matches one pattern but not another": one :g driving a :v. The inner
-- command takes no range -- giving it one is E147.
return {
  goal = 'Append "!" to lines containing "found" but not "notfound"',
  hint = 'Nest the inverse form inside the normal one.',
  start = { 'found ok', 'found notfound', 'plain', 'found also' },
  cursor = { 1, 0 },
  want = { 'found ok!', 'found notfound', 'plain', 'found also!' },
  keys = '', -- <- your answer
}
