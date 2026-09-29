# 10 — Task

Practice only. The teaching is in [`LESSON.md`](LESSON.md).

**This lesson changes `~/.config/hero`.** The reference snapshot is `config/10`.

## 1. Add the navigation you will actually use

In `~/.config/hero/init.lua`:

1. Set `hidden`, and write a comment saying what it costs as well as what it buys.
2. Map `<C-h>` `<C-j>` `<C-k>` `<C-l>` to the four window-movement commands.
3. Map `<leader>b` to something that lists the buffers and leaves you on a
   `:buffer ` command line — so you can type a few characters of a filename.
4. Map `<leader><leader>` to the alternate-buffer toggle.

**Done when** `:nmap <C-h>` shows `<C-W>h`, `:set hidden?` reports `hidden`, and
`:nmap <leader><leader>` shows the toggle.

Compare afterwards: `bash tools/use-snapshot.sh --diff 10`.

One thing to notice while you do this: `<C-i>` and `<Tab>` are the same byte
(lesson 03), and `<C-h>` has a similar history with `<BS>` on some terminals. If
`<C-h>` behaves oddly in your terminal, that is why — check with `:nmap <C-h>` and
then in a different terminal before blaming the config.

## 2. Read a `:ls` listing properly

Open five or six files, modify two of them without saving, and split a window.

```vim
:ls
```

Answer from the listing alone:

1. Which buffers are loaded but not visible? Which column told you?
2. Which have unsaved changes?
3. Which buffer is the alternate, and where will `<leader><leader>` take you?
4. Is there a buffer at `line 0`? What would put one there?
5. Now `:ls!`. What appeared, and why was it hidden from `:ls`?

Then `:wa` and run `:ls` again to see the `+` flags go.

## 3. Stop closing things to navigate

For the next twenty minutes, forbid yourself `:q` and `:bd` entirely.

- switch files with `:b {substring}`
- flip between two files with `<leader><leader>`
- open a split to compare, then `<C-w>c` when done
- use `<C-w>o` when the layout gets messy

Count the times you reach for `:q` out of habit. Closing things to navigate is the
habit this lesson replaces, and it is why the buffer list exists.

## 4. Prove the three-way independence

1. Open three files in one window. `:ls` — three buffers, one window.
2. `:sp` twice. How many buffers now? How many windows?
3. Put the *same* buffer in two windows. Edit in one. What happens in the other, and
   what does that tell you about what a window is?
4. `:tabnew`. Does the buffer count change? Does `:ls` look different?
5. `:tabclose`. Did you lose anything?

Question 3 is the one that makes the model click.

## 5. Use the argument list for a real edit

Find a rename or substitution you genuinely need across several files.

```vim
:args lua/**/*.lua
:args
```

Read that second output before going further. Then:

```vim
:argdo %s/old/new/ge | update
```

Afterwards, answer:

1. What did the `e` flag prevent? Remove it and run it again on a set where one file
   has no match, to see.
2. Why `update` and not `write`? Check a file's timestamp either way.
3. Run the same thing with `:bufdo` on a session where you have a `:help` page and a
   scratch buffer open. What got touched that you did not intend?

## 6. Drills

```bash
./drill 10
```

Eighteen drills; two are `BUG HUNT`. Most use `check` rather than keystrokes, because
buffers and windows are things you inspect rather than type at.

Drill 01's comment records a real Neovim behaviour worth knowing: an unmodified empty
buffer is *reused* when the next file loads into it, so two consecutive `:enew` calls
leave you with one buffer.

**Done when** `./drill 10` reports no `TODO` and no `FAIL`.

## 7. Write one drill

Add `exercises/19-mine-*.lua` covering something this lesson did not drill: `:windo`
against `:tabdo`, `<C-w>H` moving a window, `:badd` followed by `:bnext`, or the
`=`/`-` flag columns in `:ls`. Use `vim.cmd('silent! only')` at the start, since
window layout leaks between drills — the runner resets options and registers but not
your splits.
