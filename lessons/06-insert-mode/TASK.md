# 06 — Task

Practice only. The teaching is in [`LESSON.md`](LESSON.md).

Nothing in this lesson changes `~/.config/hero`.

## 1. Drills

```bash
./drill 06
```

Twenty drills; two are `BUG HUNT`.

Read drills 13, 14 and 15 as a set. Thirteen and fourteen use the two popup keys
and fifteen uses one of those same keys with no popup open, doing something
entirely unrelated. If you can predict all three you have the only genuinely
confusing thing in this lesson.

Drills 01, 02 and 20 are the `I` / `gI` distinction three times, because it is the
one people carry a wrong belief about for years.

**Done when** `./drill 06` reports no `TODO` and no `FAIL`.

## 2. Stop pressing Escape

Open a real file. For the next twenty minutes, forbid yourself `<Esc>` for
*corrections*. When you mistype:

- one character wrong → `<C-h>`
- last word wrong → `<C-w>`
- the whole thing wrong → `<C-u>`
- need one Normal command → `<C-o>` then the command

Count how many times you reach for `<Esc>` anyway. That number is the habit you are
replacing, and it goes down fast.

## 3. Use completion until it is automatic

Still in a real file, ideally a Lua one with long identifiers:

1. Type the first four characters of an identifier that appears elsewhere, then
   `<C-n>`.
2. Do it again with `<C-p>` and notice the search direction differs.
3. Find somewhere with two candidates and cycle to the second.
4. Complete a file path with `<C-x><C-f>`. Check `:pwd` first, and notice the paths
   are relative to *that*, not to the file you are editing.
5. Duplicate a nearly-identical line with `<C-x><C-l>`.

Then break it on purpose:

```vim
:set complete=.
```

and confirm that `<C-n>` no longer finds words from your other open buffers.
Restore with `:set complete&`.

## 4. Settle the `<C-e>` / `<C-y>` confusion permanently

1. Open a popup with `<C-n>`, press `<C-y>`, note the result.
2. Open one again, press `<C-e>`, note the result.
3. Now with **no** popup open, put the cursor on a short line directly under a
   longer one and press `<C-y>` a few times in Insert mode. Note what arrives.
4. Do the same with `<C-e>` under a longer line *below* the cursor.

Write the four results down in one place. This is the only reliable way to stop
misattributing step 2 to a broken plugin later.

## 5. Read the option that governs the menu

```vim
:set completeopt?
:h 'completeopt'
```

Find `noselect` in that help entry and answer: what problem does it solve, and what
does `<CR>` do differently once it is set? Try it:

```vim
:set completeopt+=noselect
```

then open a popup and press `<CR>`. Decide whether you want it — you will be
setting this for real when a completion plugin arrives, and knowing what the
built-in does first is what stops the plugin from being magic.

## 6. Write one drill

Add `exercises/21-mine-*.lua` for an Insert-mode key this lesson listed but did not
drill: `<C-d>`, `<C-x><C-o>`, `r`, or `<C-v>` with a decimal code rather than a
Unicode one. Assert on the buffer, and if the result depends on `'expandtab'` or
another option, set it in `setup` rather than hoping for a default.
