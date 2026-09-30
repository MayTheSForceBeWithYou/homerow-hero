-- Drill 15. For a MAP-style option, :get() returns key/value pairs rather than a list.
-- Return the value of the 'trail' key from listchars after setting it.
return {
  goal = "Set listchars trail and return the trail value from the option's table form",
  check = function()
    vim.opt.listchars = { tab = '> ', trail = '-' }

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == '-', ('expected "-", got %s'):format(tostring(answer)))
  end,
}
