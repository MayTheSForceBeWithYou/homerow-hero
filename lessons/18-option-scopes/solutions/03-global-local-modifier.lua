-- Drill 03. Some options have a local value that may be UNSET, falling back to a global
-- one. Return the boolean field that reports this, for 'statusline'.
return {
  goal = "Return whether 'statusline' is a global-local option",
  check = function()
    -- ANSWER_BEGIN
    local answer = vim.api.nvim_get_option_info2('statusline', {}).global_local
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == true, 'statusline has a window-local value that can fall back to the global')
  end,
}
