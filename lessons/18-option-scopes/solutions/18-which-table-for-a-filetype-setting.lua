-- Drill 18. The judgement the lesson turns on. A per-filetype indent setting goes in an
-- autocommand -- which of the five tables should it use?
--
-- Return the table's name as a string, e.g. 'vim.xx'.
return {
  goal = 'Return the table a per-filetype buffer-scoped setting should use',
  hint = 'Should a buffer opened later inherit it? No -- so which table leaves the global alone?',
  run = function()
    return 'vim.bo' -- <- your answer
  end,
  value = 'vim.bo',
}
