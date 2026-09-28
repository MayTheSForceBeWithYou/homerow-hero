-- Drill 01. The config directory's last path segment is the application name:
-- `/home/you/.config/nvim` ends in `nvim`. Return that last segment as a string
-- for the *currently running* Neovim, without typing it literally.
--
-- Two functions from the lesson combine to do this. The drill runs under plain
-- `nvim`, so the answer here is 'nvim' -- but a hardcoded 'nvim' does not count
-- and will not teach you anything.
return {
  goal = "Return the config directory's last path segment",
  hint = 'One function gives you the whole path; another trims a path down to its tail.',
  run = function()
    return nil -- <- your answer
  end,
  value = 'nvim',
}
