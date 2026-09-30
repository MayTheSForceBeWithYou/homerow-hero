-- Drill 06. The 5.1 spelling is a global; the 5.4 spelling does not exist here. Return
-- a list: { is_global_present, is_table_field_present }.
return {
  goal = 'Return whether the global unpack and table.unpack each exist',
  hint = 'One of these is true and one is false.',
  check = function()
    -- ANSWER_BEGIN
    local answer = { unpack ~= nil, table.unpack ~= nil }
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer[1] == true, 'the global unpack exists in 5.1')
    assert(answer[2] == false, 'table.unpack is the 5.4 name and is not here')
  end,
}
