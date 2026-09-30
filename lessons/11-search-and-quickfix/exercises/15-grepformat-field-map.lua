-- Drill 15. 'grepformat' is the field map that turns an external program's text output
-- into structured entries. Return what each placeholder means, as a list in the order
-- they appear in the ripgrep default "%f:%l:%c:%m".
--
-- Use exactly: 'file', 'line', 'column', 'message'.
return {
  goal = 'Return the meaning of each grepformat placeholder in order',
  run = function()
    return nil -- <- your answer
  end,
  value = { 'file', 'line', 'column', 'message' },
}
