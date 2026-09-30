# 19 — Task

Practice only. The teaching is in [`LESSON.md`](LESSON.md).

Nothing in this lesson changes `~/.config/hero`.

## 1. Drills

```bash
./drill 19
```

Eighteen drills; two are `BUG HUNT`. Drills 07 through 11 are the copy-on-read trap, built
up one step at a time: first the cause, then the two surfaces it appears on, then the fix.
Do them in order.

**Done when** `./drill 19` reports no `TODO` and no `FAIL`.

## 2. Confirm the two systems are one

```vim
:lua vim.g.probe = 'lua'
:echo g:probe
:let g:probe2 = 'vimscript'
:lua = vim.g.probe2
```

Then find, in your **real** config, a `vim.g.something` that configures a plugin. Work out
which Vimscript variable that plugin actually reads, and confirm with `:echo`.

That is the whole reason `vim.g` matters more than it looks: it is the interface to every
Vimscript plugin you will ever install.

## 3. Reproduce the silent loss

```vim
:lua vim.g.cfg = { a = 1 }
:lua vim.g.cfg.a = 42
:= vim.g.cfg
```

Nothing changed, and nothing complained. Now prove why in one line:

```vim
:lua local x, y = vim.g.cfg, vim.g.cfg; print(x ~= y)
```

Then get it working with the three-line pattern. Write all three lines out even though the
third feels redundant — that feeling is the bug.

Finally, try the same thing with `vim.b` and `vim.t`. Is the behaviour the same?

## 4. Map the scopes to real needs

For each of these, decide which of the six tables you would use, and why:

1. Turning on a Vimscript plugin's feature flag.
2. Remembering that *this buffer* was opened from a git diff.
3. Remembering which pane of *this window* the user last focused.
4. A layout marker for a debugging tab page.
5. Making `RUST_BACKTRACE=1` visible to a language server you are about to start.
6. A counter your own module increments on every save.

Number 6 is the one where the answer is *not* one of the six. Say what it is instead and
why.

## 5. Use the count in a mapping

```vim
:lua vim.keymap.set('n', '<leader>c', function() print('count =', vim.v.count, 'count1 =', vim.v.count1) end)
```

Press `<leader>c`. Then press `3<leader>c`. Then `1<leader>c`.

Write down all three pairs. Then answer: if the mapping multiplied something by the count,
which variable must it use, and what would the other one do with no count typed?

## 6. Find out what else `v:` has

```vim
:h vim-variable
```

Skim the list and find three you did not know existed. For each, say whether it is writable
and when you would read it. `v:shell_error`, `v:this_session` and `v:register` are good
candidates.

Then check one of your guesses:

```vim
:lua vim.v.register = 'x'
```

## 7. Use `vim.env` for something real

1. `:= vim.env.PATH`
2. Set a variable: `:lua vim.env.HERO_TEST = 'hello'`
3. Confirm a **child process** sees it: `:!echo $HERO_TEST`
4. Now open a `:terminal` and `echo $HERO_TEST` there too.
5. Explain why a language server started *before* step 2 would not see it.

## 8. Write one drill

Add `exercises/19-mine-*.lua` for something this lesson mentioned but did not drill:
`vim.w` independence across two windows, `v:shell_error` after a failing `:!`, `v:errmsg`
being writable, or the type conversion of a Lua *list* stored in `vim.g` and read back in
Vimscript. Clean up whatever globals you set — they persist between drills, and the runner
resets registers and options but not variables.
