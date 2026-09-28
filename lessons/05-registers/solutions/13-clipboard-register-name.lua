-- Drill 13. Recall. Return the register name -- one character -- for the system
-- clipboard: the one whose contents Ctrl+V pastes in other applications.
return {
  goal = 'Return the register name for the system clipboard',
  hint = 'The other candidate is the X11 primary selection.',
  run = function()
    return '+' -- <- your answer
  end,
  value = '+',
}
