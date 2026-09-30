-- Drill 15. Build config/17's helper. It must return the module when present, and when
-- absent return nil AFTER reporting -- keeping the error text in the message, because
-- "not found" and "threw while loading" need different fixes.
--
-- The check stubs vim.notify so it can confirm you reported rather than returned silently,
-- and it creates a real module on the runtimepath so the present branch is tested too.
return {
  goal = 'Write an optional-require helper that returns the module, or nil after reporting',
  hint = 'pcall, return the module on success, otherwise notify with the captured error and return nil.',
  check = function()
    -- A module that really exists, so both branches get exercised.
    local dir = vim.fn.tempname()
    vim.fn.mkdir(dir .. '/lua', 'p')
    vim.fn.writefile({ "return { marker = 'present' }" }, dir .. '/lua/d15present.lua')
    vim.opt.runtimepath:prepend(dir)
    package.loaded['d15present'] = nil

    local notified = {}
    local real_notify = vim.notify
    vim.notify = function(msg, level)
      notified[#notified + 1] = { msg = tostring(msg), level = level }
    end

    -- ANSWER_BEGIN
    local function optional(name)
      local ok, mod = pcall(require, name)
      if ok then
        return mod
      end
      vim.notify(('optional module %s unavailable: %s'):format(name, mod), vim.log.levels.DEBUG)
      return nil
    end
    -- ANSWER_END

    local present, missing
    if optional then
      present = optional('d15present')
      missing = optional('d15_absent_module_probe')
    end
    vim.notify = real_notify

    assert(optional ~= nil, 'DRILL_TODO')
    assert(
      type(present) == 'table' and present.marker == 'present',
      'a present module must come back'
    )
    assert(missing == nil, 'an absent module should yield nil')
    assert(#notified == 1, ('expected exactly one notification, got %d'):format(#notified))
    assert(
      notified[1].msg:find('d15_absent_module_probe', 1, true),
      ('the message should name the module, got %q'):format(notified[1].msg)
    )
    assert(
      notified[1].msg:find('not found', 1, true),
      ('the message should include the captured error text, got %q'):format(notified[1].msg)
    )
  end,
}
