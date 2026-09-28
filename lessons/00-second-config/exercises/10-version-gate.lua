-- Drill 10. Configs in the wild guard 0.12-only APIs behind a version test.
-- The classic spelling is a feature string like 'nvim-0.12' passed to has().
--
-- Return true if this Neovim is at least 0.12. Note that has() returns a
-- *number* (1 or 0), not a boolean -- converting it is part of the drill, and
-- it is the reason `if vim.fn.has('x') then` is always true and always wrong.
return {
  goal = 'Return whether this Neovim is at least version 0.12, as a boolean',
  hint = 'has() answers with 1 or 0.',
  run = function()
    return nil -- <- your answer
  end,
  value = true,
}
