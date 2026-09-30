-- Drill 02. Return the scopes of three options as a list, in this order:
-- 'number', 'hlsearch', 'expandtab'.
return {
  goal = 'Return the scopes of number, hlsearch and expandtab in that order',
  check = function()
    -- ANSWER_BEGIN
    local answer = {
      vim.api.nvim_get_option_info2('number', {}).scope,
      vim.api.nvim_get_option_info2('hlsearch', {}).scope,
      vim.api.nvim_get_option_info2('expandtab', {}).scope,
    }
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer[1] == 'win', 'number is window-scoped')
    assert(answer[2] == 'global', 'hlsearch is global')
    assert(answer[3] == 'buf', 'expandtab is buffer-scoped')
  end,
}
