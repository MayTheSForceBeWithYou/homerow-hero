-- Drill 04. A local exists only below its declaration, so a function whose body
-- references a LATER local compiles that reference as a global lookup.
--
-- Return true if calling it fails.
return {
  goal = 'Return whether a function referencing a later local fails when called',
  check = function()
    local chunk = load([[
      local function a() return b() end
      local function b() return 1 end
      return a()
    ]])

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == true, 'b was not a local when a was compiled, so the call fails')
  end,
}
