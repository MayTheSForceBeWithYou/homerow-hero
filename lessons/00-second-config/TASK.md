# 00 — Task

Practice only. The teaching is in [`LESSON.md`](LESSON.md).

## 1. Build the practice config

```bash
mkdir -p ~/.config/hero
```

Create `~/.config/hero/init.lua` containing a single line that sets
`vim.g.hero_config_loaded` to `true`, plus a comment saying what the file is for.

Add the alias to your shell config:

```bash
alias hero='NVIM_APPNAME=hero nvim'
```

Reload your shell (`exec zsh`) and confirm `hero` starts.

**Done when:** inside `hero`, `:lua = vim.g.hero_config_loaded` prints `true`,
and `:lua = vim.fn.stdpath('config')` ends in `/hero`.

The reference version is `config/00/` in this repo. Compare only after you have
written your own.

## 2. Prove the isolation

Answer each by running something, not by reasoning:

1. What does `stdpath('data')` report under `hero` versus under plain `nvim`?
2. Start `hero` and run `:echo $MYVIMRC`. Now start `nvim --clean` and run the
   same. Explain the difference in one sentence.
3. Find one `stdpath` key whose value is **not** renamed by `NVIM_APPNAME`.

## 3. Break it on purpose

You need to recognize these before they happen for real.

1. Add a deliberate syntax error to the **last** line of `~/.config/hero/init.lua`.
   Start `hero`. Record the exact error text. Does `vim.g.hero_config_loaded`
   still come back `true`? Explain why or why not.
2. Now move the broken line to the **first** line and repeat. Same question.
3. Create `~/.config/hero/init.vim` alongside `init.lua`. Start `hero` and record
   what happens. Delete it.

Write the three error messages down somewhere you will keep. You will meet all
three again.

## 4. Startup flags

Run each and note the difference you can actually observe:

```bash
hero --headless -c 'lua print(vim.g.hero_config_loaded)' -c qa
hero --clean --headless -c 'lua print(vim.g.hero_config_loaded)' -c qa
```

Then work out — by running it, not guessing — what this prints and why the two
flags disagree:

```bash
hero --headless --cmd 'lua vim.g.hero_config_loaded = "from --cmd"' \
     -c 'lua print(vim.g.hero_config_loaded)' -c qa
```

## 5. Drills

```bash
./drill 00
```

Every drill starts at `TODO`. Fill in the answer in each
`lessons/00-second-config/exercises/*.lua` file and re-run until it passes.
Two drills have a wrong answer pre-filled and are marked `BUG HUNT` — those start
at `FAIL`, and the fix is the exercise.

Check a reference answer only after a real attempt:

```bash
./drill 00 --solutions
```

**Done when** `./drill 00` reports no `TODO` and no `FAIL`.
