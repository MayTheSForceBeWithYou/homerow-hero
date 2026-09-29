-- Drill 02. `require('a.b.c')` looks for lua/a/b/c.lua. Return the module NAME you would
-- pass to require for a file at lua/hero/sub/deep.lua.
return {
  goal = 'Return the require name for the file lua/hero/sub/deep.lua',
  hint = 'The lua/ directory is where the search starts, so it is not part of the name.',
  run = function()
    return nil -- <- your answer
  end,
  value = 'hero.sub.deep',
}
