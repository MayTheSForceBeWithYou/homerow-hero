-- Drill 03. A control key is documented once per mode. Return the tag for CTRL-W as it
-- behaves in INSERT mode -- the delete-word-back key from lesson 06.
--
-- Note that the docs spell control keys CTRL-W, not <C-w>.
return {
  goal = 'Return the help tag for CTRL-W in Insert mode',
  hint = 'A two-character prefix.',
  run = function()
    return nil -- <- your answer
  end,
  value = 'i_CTRL-W',
}
