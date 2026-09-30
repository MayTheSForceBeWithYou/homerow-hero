-- Drill 06. Same cursor as drill 05, uppercase object. A WORD is delimited only
-- by whitespace, so `obj.method(x)` is a single WORD and the dots and brackets do
-- not break it up.
--
-- Use the `i` size here and note that the space after "call" survives -- if you
-- reach for `daW` instead you get "call" with no space, because this WORD is last
-- on the line and `a` then takes the *leading* whitespace, exactly as in drill 04.
return {
  goal = 'Delete the whole expression obj.method(x), leaving the space after "call"',
  hint = 'Uppercase ignores punctuation. Use the size that leaves whitespace alone.',
  start = { 'call obj.method(x)' },
  cursor = { 1, 10 },
  want = { 'call ' },
  keys = 'diW',
}
