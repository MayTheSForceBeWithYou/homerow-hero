# 04 — Task

Practice only. The teaching is in [`LESSON.md`](LESSON.md).

**This lesson changes `~/.config/hero`.** The reference snapshot is `config/04`.

## 1. Write the config

Open your practice config:

```bash
hero ~/.config/hero/init.lua
```

It currently holds one line from lesson 00. Add, in this order:

1. `mapleader` and `maplocalleader`, both set to a space.
2. The six options from the lesson's table: `number`, `expandtab`, `shiftwidth`,
   `tabstop`, `ignorecase`, `smartcase`.
3. One keymap: `<leader>n` clearing the search highlight, with a `desc`.

Keep `vim.g.hero_config_loaded = true` as the last line.

Write comments saying *why*, not what. `vim.opt.number = true -- enable numbers`
is noise; a line explaining why `ignorecase` without `smartcase` is a trap is not.

**Done when** all four of these hold, checked from inside `hero`:

```vim
:lua = vim.g.hero_config_loaded    " true
:set shiftwidth?                   " shiftwidth=2
:nmap <leader>n                    " lhs column shows <Space>n
:verbose set expandtab?            " names your init.lua
```

Compare with `config/04` only after yours works:

```bash
bash tools/use-snapshot.sh --diff 04
```

## 2. Practise the loop until it is boring

1. Change `shiftwidth` to 4. `:source %`. Confirm with `:set shiftwidth?`.
2. Change it back to 2. `:source %`. Confirm again.
3. Now do it without `:source` — edit, then check. Watch the value *not* change.
   That is the failure mode you are inoculating against: editing a file is not
   applying it.

## 3. Reproduce the leader trap on purpose

You will hit this for real in lesson 28, when plugins start declaring keys. Meet
it now, where it is cheap.

1. Move the `vim.g.mapleader` line to the **bottom** of the file, just above the
   `hero_config_loaded` line. Restart `hero` — a real restart, not `:source`.
2. Press `<Space>n`. Nothing happens.
3. Run `:nmap <leader>n` and read the lhs column. Write down what it says.
4. Now press `\n` — backslash, then n. It works.
5. Move `mapleader` back to the top and restart.

Step 3 is the whole exercise. The listing tells you the answer in one glance, and
knowing to look there is the skill.

## 4. Ask Neovim instead of guessing

For each question, find the answer with a command rather than by reading your
config:

1. What is `'tabstop'` set to, and which file set it?
2. Is `'smartcase'` on?
3. What is `<leader>n` bound to right now — the rhs, exactly?
4. Does your `<leader>n` mapping have a `desc`? How can you tell from the listing?
5. Deliberately break something: set `vim.opt.shiftwidth = "two"` and restart.
   Record the exact error, then find it again with `:messages`.
6. Is `vim.g.hero_config_loaded` still `true` after that break? Explain the result
   in terms of where the broken line sits in the file.

Question 6 has a different answer depending on where you put the broken line. Try
it both above and below the marker.

## 5. Drills

```bash
./drill 04
```

Nineteen drills; two are `BUG HUNT`. Several ask you to *write a line* rather than
fill in a value — those ship with an `error('DRILL_TODO')` line that you delete
once you have written your answer, which is why they report `TODO` rather than
`FAIL` to begin with.

Drill 03 is worth noticing: it is lesson 01's indent drill again, and this time the
expected result is two spaces rather than a tab, because you set the options that
make it so.

Drills 06 and 07 are the leader trap in isolation. Do them before step 3 above if
you want the answer, or after if you want to work it out yourself.

**Done when** `./drill 04` reports no `TODO` and no `FAIL`.

## 6. Write one drill

Add `exercises/20-mine-*.lua` that proves an option *you* care about is set, using
the `check` shape: set it on the marked line, and assert the effect rather than the
assignment. Asserting `vim.o.x == v` right after writing `vim.opt.x = v` tests
almost nothing; asserting an observable consequence — as drill 03 does with `>>` and
drill 04 does with `search()` — tests something real.
