# 05 — Task

Practice only. The teaching is in [`LESSON.md`](LESSON.md).

**This lesson changes `~/.config/hero`.** The reference snapshot is `config/05`.

## 1. Make the clipboard decision

Add to `~/.config/hero/init.lua`:

1. Mappings that put the system clipboard behind `<leader>y` and `<leader>p`, in
   both Normal and Visual mode.
2. A mapping for `<leader>Y` that yanks the whole line to the clipboard.
3. A mapping for `<leader>0` that puts the last **yank** rather than the last
   delete.

Do **not** set `vim.opt.clipboard = 'unnamedplus'` yet — try it deliberately in
step 3 below and decide for yourself.

**Done when** `:nmap <leader>y` shows a rhs of `"+y`, and `:vmap <leader>y` shows
the same mapping exists in Visual mode.

Compare afterwards: `bash tools/use-snapshot.sh --diff 05`.

## 2. Find out whether your clipboard actually works

The lesson's measured example shows every health indicator reporting fine while
nothing reached the OS. Do not trust yours until you have checked it the honest
way.

1. From inside `hero`, run each of these and write the results down:
   ```vim
   :lua = vim.fn.has('clipboard')
   :lua = vim.fn.has('clipboard_working')
   :lua = vim.fn['provider#clipboard#Executable']()
   ```
2. Now the real test. Yank a line with `<leader>Y`, switch to **another
   application** — a browser, a Windows app — and press Ctrl+V.
3. If it did not arrive, ask the provider directly from a shell. For whichever
   provider step 1 named:
   ```bash
   wl-paste --no-newline ; echo "exit=$?"
   # or: xclip -o -selection clipboard ; echo "exit=$?"
   ```
4. If the provider is failing on WSL, read `:h clipboard-wsl` and decide whether to
   install `win32yank.exe`. You do not have to fix it today — you have to know
   which of the two situations you are in.

Write down the answer, because a later lesson will not remind you and a broken
clipboard is invisible until it matters.

## 3. Try the other decision, then choose

1. Add `vim.opt.clipboard = 'unnamedplus'` and `:source %`.
2. Copy some text in another application.
3. In `hero`, `dd` any line.
4. Go back to the other application and press Ctrl+V.

Now you know the cost first-hand. Keep the setting or remove it — but record which
you chose and why in a comment, because in lesson 27 you will be moving these lines
into a module and you want the reason to travel with them.

## 4. Drills

```bash
./drill 05
```

Eighteen drills; two are `BUG HUNT`.

Drill 01 is unusual: it asks you to produce the **wrong-looking** result on purpose,
because predicting it correctly is the point. Drills 02, 03 and 04 are three
different ways out of it — do all three rather than stopping at the first.

Note that several drills call `vim.fn.setreg(…, '')` in `setup`. Registers are
global and survive from one drill to the next, so a drill that did not clear them
could pass on a leftover value. If you write your own, clear what you read.

**Done when** `./drill 05` reports no `TODO` and no `FAIL`.

## 5. Read your own registers

Open a file, do fifteen minutes of ordinary editing — some `dd`, some `x`, some
`ciw`, a couple of yanks — then:

```vim
:registers
```

Answer from the listing, not from memory:

1. What is in `"0`, and when did it get there?
2. How many of `"1`–`"9` are populated, and what does that tell you about the
   *kind* of deletes you have been doing?
3. Find a register whose Type column is `l` and one whose Type is `c`. Predict
   what `p` would do with each, then try both and confirm.
4. Is `"-` populated? What put it there?
5. What is in `".`, and can you find a use for `"​.p` in what you were just doing?

## 6. Write one drill

Add `exercises/19-mine-*.lua` that proves something about a register you did not
drill above — `"/`, `"#`, `"%`, blockwise yank, `gp`, or `]p`. Assert on an
observable consequence rather than on the register's contents where you can, and
clear in `setup` whatever you read.
