# homerow-hero

A self-study course that teaches **Vim's editing model**, **Neovim**, and **the
Lua that configures it** — with a bias toward the `vim.` object model and toward
owning a config directory you are not afraid of.

Thirty lessons. You build a practice config from an empty file to one with
lazy.nvim, plugin files, your own modules and your own keymaps bound to functions
you wrote. Your real config is never touched.

There is no capstone project. The point is the fluency, not a deliverable.

## Start here

1. Read [`DESIGN.md`](DESIGN.md) — the curriculum, the environment, the standards.
2. Begin at [`lessons/00-second-config/LESSON.md`](lessons/00-second-config/LESSON.md).
3. Do the lesson, then its `TASK.md`, then its drills.

```bash
./drill 00               # your answers for lesson 00
./drill 00 --solutions   # the reference answers
```

Work only in each lesson's `exercises/`. Look in `solutions/` after a real
attempt.

## How a lesson is shaped

```
lessons/NN-slug/
├── LESSON.md     teaches -- the only file that teaches
├── TASK.md       practice: what to run, what to build, how you know you're done
├── exercises/    your work; drills with the answer blanked
└── solutions/    reference answers, same filenames
config/NN/        the practice config as it stands after lesson NN
```

`:help` is **lookup** — the lesson tells you what to look for and how to
recognize it; `:help` supplies the spelling afterward.

## The drill runner

Editor skill is usually untestable, which is why most Vim material is a list of
commands and a wish of luck. Here it is machine-checked: a drill declares a
starting buffer, a cursor position and the buffer you should end up with, and the
runner feeds your keystrokes into a real headless Neovim and compares the result.

```lua
-- lessons/01-operator-grammar/exercises/06-delete-till-exclusive.lua
return {
  goal = 'Delete up to but not including the first "o"',
  hint = 'Think of it as "till".',
  start = { 'the quick brown fox' },
  cursor = { 1, 0 },
  want = { 'own fox' },
  keys = '', -- <- your answer
}
```

```console
$ ./drill 01
  TODO   06-delete-till-exclusive -- Delete up to but not including the first "o"
  FAIL   24-bug-hunt-eaten-space
        goal: Delete "alpha" without disturbing the space that followed it
        buffer differs:
          got:
           1|beta gamma
          want:
           1| beta gamma
        hint: Which word motion stops *on* the last character of the word?

24 drills: 0 pass, 22 todo, 2 fail
```

Drills also assert on cursor position, registers and mode, and two other drill
kinds check Lua values and free-form assertions. `BUG HUNT` drills ship with a
wrong answer already in place; diagnosing it is the exercise.

Usage:

```bash
./drill 04                 # lesson 04's exercises
./drill 04 --solutions     # its reference answers
./drill 04/11              # one drill
./drill --all              # everything you've attempted
./drill --all-solutions    # every reference answer (what CI runs)
```

## Your real config is never at risk

All practice happens in a second Neovim config, selected by `NVIM_APPNAME`:

```bash
alias hero='NVIM_APPNAME=hero nvim'
```

That one variable redirects the config, data, state **and** cache directories to
`~/.config/hero`, `~/.local/share/hero`, and so on. Plugins install under *data*,
so the practice config downloads its own lazy.nvim and cannot disturb what your
working config has pinned. Lesson 00 sets this up and proves it.

`tools/use-snapshot.sh` installs a reference snapshot into `~/.config/hero`, and
refuses to run against `~/.config/nvim`.

## Roadmap

Full table with per-lesson concepts in [`DESIGN.md`](DESIGN.md) §3.

| Phase | Lessons | Ground covered |
|---|---|---|
| **A — Ground** | 00–04 | second config, startup order, modes, the operator + motion grammar, text objects, marks and jumps, first `init.lua` |
| **B — Editing at speed** | 05–09 | registers and clipboard, insert mode and completion, macros and the dot formula, Ex ranges and `:substitute`, `:global` and `:normal` |
| **C — The workspace** | 10–12 | buffers vs windows vs tabs, search and quickfix, `:help` as a database |
| **D — Lua as Neovim runs it** | 13–17 | `:lua`, LuaJIT vs 5.4, tables, functions and closures, modules and `require`, `pcall` and tracebacks |
| **E — The `vim.` object model** | 18–26 | option scopes, variable scopes, `vim.cmd`, `vim.fn`, `vim.api`, **keymaps to your own functions**, autocommands, user commands, async |
| **F — A config you can trust** | 27–29 | config architecture and load order, lazy.nvim, lazy loading and diagnosing a broken config |

Roughly 84 hours at a steady pace, spread over as long as you like.

## Status

See [`docs/STATUS.md`](docs/STATUS.md) for what is written. The curriculum in
`DESIGN.md` is settled; lessons are authored in order, and no lesson is committed
until its drills pass.

## Environment

Developed and verified on **WSL2 / Arch Linux**, **Neovim 0.12.5**, in the Linux
filesystem (never under `/mnt/c/…`).

One fact that matters throughout: **Neovim runs LuaJIT — Lua 5.1 plus
extensions** — not the Lua 5.5 that `lua -v` reports on this machine. Lesson 13
makes the distinction explicit, because verifying a config idiom with `lua -e` and
getting a different answer than Neovim gives is a genuinely confusing afternoon.

## Verifying the repo itself

```bash
stylua --check .
./drill --all-solutions
bash tools/use-snapshot.sh --verify-all
```

CI runs all three. There are no tests that pass without checking anything.

## Contributing to your own copy

[`AUTHORING.md`](AUTHORING.md) is the depth bar and the drill contract.
[`CLAUDE.md`](CLAUDE.md) holds the rules for AI assistants working in this repo —
most importantly that lessons are written in order, that output is transcribed
rather than composed, and that there is no capstone.

## License

MIT — see [LICENSE](LICENSE).
