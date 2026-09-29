-- Drill 18. BUG HUNT -- starts FAILING.
--
-- The guard works: an absent module does not break startup. But the report says only that
-- something went wrong, so "not found" and "threw on line 4" are indistinguishable -- and
-- those need completely different fixes.
--
-- pcall already handed over the reason. Stop dropping it.
return {
  goal = 'Report the captured reason when an optional require fails',
  hint = 'pcall returns two values.',
  check = function()
    local notified = {}
    local real_notify = vim.notify
    vim.notify = function(msg)
      notified[#notified + 1] = tostring(msg)
    end

    local function optional(name)
      if not pcall(require, name) then
        vim.notify(('optional module %s unavailable'):format(name), vim.log.levels.DEBUG)
        return nil
      end
      return require(name)
    end

    optional('d18_absent_module_probe')
    vim.notify = real_notify

    assert(#notified == 1, ('expected one notification, got %d'):format(#notified))
    assert(
      notified[1]:find('d18_absent_module_probe', 1, true),
      'the message should name the module'
    )
    assert(
      notified[1]:find('not found', 1, true),
      ('the message should include the captured reason, got %q'):format(notified[1])
    )
  end,
}
