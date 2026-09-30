-- Drill 16. The lesson argues for a specific order: precise before broad, because a tag
-- is a definition point while a text search returns every passing mention.
--
-- Return the four steps in the order you should try them, using exactly these strings:
--   'tag completion', 'wildcard', 'helpgrep', 'index'
return {
  goal = 'Return the four lookup steps in escalating order',
  run = function()
    return nil -- <- your answer
  end,
  value = { 'tag completion', 'wildcard', 'helpgrep', 'index' },
}
