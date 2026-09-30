-- Drill 14. The reason the Option object exists. Build a list option by assignment, then
-- append, prepend and remove -- and return the final value as a table.
return {
  goal = 'Assign a list option then append, prepend and remove, returning the result',
  hint = 'Three methods on the Option object, then :get().',
  check = function()
    -- ANSWER_BEGIN
    vim.opt.wildignore = { '*.o', '*.pyc' }
    vim.opt.wildignore:append('*.so')
    vim.opt.wildignore:prepend('*.a')
    vim.opt.wildignore:remove('*.pyc')
    local answer = vim.opt.wildignore:get()
    -- ANSWER_END

    assert(answer ~= nil, 'DRILL_TODO')
    assert(
      table.concat(answer, ',') == '*.a,*.o,*.so',
      ('expected *.a,*.o,*.so -- got %s'):format(table.concat(answer, ','))
    )
  end,
}
