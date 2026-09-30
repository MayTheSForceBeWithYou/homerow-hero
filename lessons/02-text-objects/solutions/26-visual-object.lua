-- Drill 26. The other place objects are legal: Visual mode. Select first, then
-- operate -- useful when you want to see the extent before committing.
return {
  goal = 'Select the word under the cursor visually, then uppercase it',
  start = { 'make this loud' },
  cursor = { 1, 6 },
  want = { 'make THIS loud' },
  keys = 'viwU',
}
