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
      -- Keeping the second return value. `if not pcall(...)` discards it, which leaves the
      -- report unable to distinguish a missing module from one that threw while loading.
      local ok, mod = pcall(require, name)
      if not ok then
        vim.notify(('optional module %s unavailable: %s'):format(name, mod), vim.log.levels.DEBUG)
        return nil
      end
      return mod
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
