-- Drill 12. Guard a require for a module that may legitimately be absent, keeping the
-- error text so that "not found" and "threw while loading" stay distinguishable.
--
-- Return a list: { ok, whether_the_error_text_was_kept }.
return {
  goal = 'Protect a require of a missing module and keep the reason',
  hint = 'pcall takes the function and its arguments separately.',
  check = function()
    -- ANSWER_BEGIN
    local ok, err = pcall(require, 'hero_definitely_not_installed')
    local answer = { ok, err ~= nil }
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer[1] == false, 'a missing module should fail')
    assert(answer[2] == true, 'and you should have kept the reason')
  end,
}
