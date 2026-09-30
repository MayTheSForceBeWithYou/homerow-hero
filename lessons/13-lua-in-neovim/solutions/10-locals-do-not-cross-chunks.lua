-- Drill 10. Each :lua command is its own chunk, so a local does not survive into the
-- next one -- while a global does. Run two pairs of chunks and report both outcomes.
--
-- Return a list of two booleans: { did_the_local_cross, did_the_global_cross }.
return {
  goal = 'Return whether a local and a global each survive into a second chunk',
  hint = 'load() compiles a chunk; run one, then another that tries to read the name.',
  check = function()
    _G.chunk_global_probe = nil

    load('local chunk_scoped = 42')()
    local local_seen = load('return chunk_scoped')()

    load('chunk_global_probe = 42')()
    local global_seen = load('return chunk_global_probe')()

    -- ANSWER_BEGIN
    local answer = { local_seen ~= nil, global_seen ~= nil }
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(type(answer) == 'table' and #answer == 2, 'expected a list of two booleans')
    assert(answer[1] == false, 'a local must NOT cross chunks')
    assert(answer[2] == true, 'a global DOES cross chunks')
    _G.chunk_global_probe = nil
  end,
}
