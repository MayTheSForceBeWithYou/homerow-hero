return {
  goal = 'Append "!" after the first comma on every line',
  hint = 'One keystroke here inherits the cursor column. Give it a known one to start from.',
  start = { 'aaa,bbb', 'a,bbbbb', 'aa,bbbb' },
  cursor = { 1, 0 },
  want = { 'aaa,!bbb', 'a,!bbbbb', 'aa,!bbbb' },
  setup = function()
    vim.fn.setreg('q', '')
  end,
  -- Repetition one ended with the cursor at column 4, and `j` carried that column to
  -- line 2 -- whose comma is at column 1, behind it. `f` only searches forward, so
  -- the motion failed and the macro aborted. `0` gives every repetition the same
  -- known starting column.
  keys = 'qq0f,a!<Esc>jq99@q',
}
