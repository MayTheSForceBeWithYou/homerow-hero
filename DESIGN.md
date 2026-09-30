# DESIGN.md — the specification for homerow-hero

This file is authoritative. Where anyone's instincts disagree with it — including
an AI assistant's — follow it or change it deliberately, in a commit that says why.

---

## 0. What this project is, and what it is not

**This repository is a course that teaches a human to use Neovim and to write the
Lua that configures it.** The human writes the config. The course writes the
lessons that make that possible.

It is **not**:

- a Neovim distribution,
- a plugin,
- a config to copy,
- a single "capstone" project with lessons bolted on the front.

That last one killed the first attempt. An earlier draft of this repo shipped
seven directories of scaffolding plus `06-capstone/`, and because the capstone was
the only artifact that looked like a *goal*, all authoring effort bent toward it.
Lessons became preambles. **There is no capstone in this design and there must
never be one.** The learner's reward is a config they understand and an editor
they are fast in — not a finished deliverable.

### The three things the learner must be able to do at the end

Every lesson is justified by one of these. A lesson that serves none of them does
not belong.

1. **Edit text in Neovim fluently** — reach any point in a file and change it
   with a composed command, without thinking about the keystrokes.
2. **Read and write the `vim.` Lua object model** — know which of `vim.opt`,
   `vim.o`, `vim.bo`, `vim.g`, `vim.fn`, `vim.api` a given job needs, and why.
3. **Own a config directory without fear** — add a plugin, add a module, add a
   keymap bound to a function they wrote, and know how to find out what broke
   when something breaks.

---

## 1. Environment

The target is the author's real setup, verified against it:

| | |
|---|---|
| OS | WSL2, Arch Linux, in the Linux filesystem (`~/…`, never `/mnt/c/…`) |
| Neovim | **0.12.x** (`nvim --version` reports `NVIM v0.12.5` at time of writing) |
| Lua | LuaJIT 2.1 **inside** Neovim; system `lua` is 5.5 and is *not* what configs run on |
| Shell | zsh interactively; `bash` for every script in this repo |

Two facts follow from this and must be honored everywhere:

- **Neovim runs LuaJIT, which is Lua 5.1 plus extensions.** Not 5.4, not the
  5.5 that `lua -v` prints in this environment. Integer division `//`,
  `<close>` variables, and `goto`-free 5.4 idioms do not transfer. Lesson 13
  teaches this distinction explicitly because getting it wrong is a silent
  source of "why does this work in the REPL but not in my config".
- **Everything targets 0.12.** Where a 0.12 API supersedes an older one
  (`vim.lsp.config`/`vim.lsp.enable` over `require('lspconfig')`,
  `vim.uv` over `vim.loop`, `vim.system` over `jobstart`), teach the new one and
  name the old one once so the learner recognizes it in other people's configs.

### Isolation: the learner never edits their real config

All practice happens in a **second config** selected by `NVIM_APPNAME`:

```bash
NVIM_APPNAME=hero nvim
```

which reads `~/.config/hero/` and writes `~/.local/share/hero/`,
`~/.local/state/hero/` and `~/.cache/hero/` — verified:

```
$ NVIM_APPNAME=hero nvim --headless -u NONE -l probe.lua
config: /home/n8/.config/hero
data:   /home/n8/.local/share/hero
state:  /home/n8/.local/state/hero
```

This is the design's answer to "I want to add things **without breaking
everything**". The learner's working editor stays untouched for all thirty
lessons; nothing in this repo may write to `~/.config/nvim`, and
`tools/use-snapshot.sh` refuses to.

---

## 2. Repository layout

```
homerow-hero/
├── README.md              entry point and roadmap
├── DESIGN.md              this file — the specification
├── AUTHORING.md           how to write a lesson; the depth bar
├── CLAUDE.md              behavioral rules for AI assistants
├── drill                  the drill runner's CLI wrapper
├── tools/
│   ├── drill.lua          headless drill runner
│   └── use-snapshot.sh    install config/NN into ~/.config/hero
├── lessons/
│   └── NN-slug/
│       ├── LESSON.md      teaches. The only place that teaches.
│       ├── TASK.md        practice instructions. Never a second lecture.
│       ├── exercises/     the learner's work — drills with blank answers
│       └── solutions/     reference answers, mirrored filenames
├── config/
│   └── NN/                cumulative config snapshot as of lesson NN
├── appendices/            symptom-indexed reference material
└── docs/                  roadmap and cross-cutting notes
```

### `lessons/` rules

- `LESSON.md` **teaches**. Prose, worked examples, recognition rules.
- `TASK.md` is **practice only** — what to run, what to implement, how you know
  you are done. If a `TASK.md` tells the learner to read `:help foo` *in order to
  learn the concept*, that task is wrong: teach it in `LESSON.md` and list the
  help tag under Lookup.
- `:help` and `:h` tags are **lookup**, not the teacher.
- Drill filenames are `NN-slug.lua`, and `solutions/NN-slug.lua` mirrors
  `exercises/NN-slug.lua` exactly.

### `config/` rules

- `config/NN/` is `config/NN-1/` **plus exactly what lesson NN changed.**
  `diff -r config/04 config/05` must show only that lesson's delta. No drive-by
  refactors, no tidying.
- A snapshot appears only for lessons that change the config. Lessons 01–03 are
  pure editor skill and add none.
- **Every snapshot must start Neovim cleanly** — zero errors, verified by
  `tools/use-snapshot.sh --verify NN`, which CI runs for every snapshot.

---

## 3. The curriculum — 30 lessons, six phases

Times assume the learner types rather than copies, and stops to make the mistakes
the "Common errors" sections describe.

### Phase A — Ground (00–04) · ~10h

| # | Lesson | Teaches | Config after |
|---|--------|---------|--------------|
| 00 | A second config, and what Neovim reads at startup | `NVIM_APPNAME`, `stdpath()`, startup order, `-u NONE`, `--clean` | bare `init.lua` |
| 01 | Modes and the operator + motion grammar | `{count}{operator}{motion}`, why `d2w` and `2dw` differ, `:h operator` | — |
| 02 | Text objects | `iw`/`aw`, `i(`/`a(`, `it`/`at`, quotes, why `ci"` beats `f"ct"` | — |
| 03 | Marks, jumps, and getting back | `` ` ``/`'`, `<C-o>`/`<C-i>`, `''`, jumplist vs changelist | — |
| 04 | Your first `init.lua`: options and one keymap | `vim.opt`, `vim.keymap.set`, leader, reload loop | options + 1 keymap |

### Phase B — Editing at speed (05–09) · ~14h

| # | Lesson | Teaches | Config after |
|---|--------|---------|--------------|
| 05 | Registers and the clipboard | named/numbered/small-delete registers, `"+`/`"*`, WSL clipboard | `clipboard` decision |
| 06 | Insert mode and completion | `<C-w>`/`<C-u>`/`<C-r>`, `<C-n>`/`<C-x><C-f>`, `'complete'` | — |
| 07 | Macros and the dot formula | `q`, `@`, `@@`, one-keystroke-motion + one-keystroke-change | — |
| 08 | Ex ranges and `:substitute` | `:%`, `:'<,'>`, `:.,+3`, flags, `\zs`, `&` | — |
| 09 | `:global` and `:normal` | `:g/pat/cmd`, `:v`, `:g/pat/normal @q`, the batch-edit mindset | — |

### Phase C — The workspace (10–12) · ~8h

| # | Lesson | Teaches | Config after |
|---|--------|---------|--------------|
| 10 | Buffers, windows, tabs, the arglist | the three-way distinction, `:b`, `:sp`, `:argdo`, `'hidden'` | window keymaps |
| 11 | Search, `:grep`, quickfix, location lists | `/` offsets, `:vimgrep`, `:cdo`, `'grepprg'`, quickfix vs loclist | quickfix keymaps |
| 12 | `:help` as a database | tag syntax (`'opt'` vs `:cmd` vs `func()`), `:helpgrep`, `<C-]>` | — |

### Phase D — Lua as Neovim runs it (13–17) · ~14h

| # | Lesson | Teaches | Config after |
|---|--------|---------|--------------|
| 13 | Lua in Neovim | `:lua`, `:lua=`, `:source`, chunks, **LuaJIT ≠ 5.4** | — |
| 14 | Tables, the only data structure | list vs map halves, `#`, `nil` holes, `vim.tbl_*`, `vim.inspect` | — |
| 15 | Functions, closures, and `local` | `local function`, upvalues, the accidental-global trap, varargs | — |
| 16 | Modules, `require`, and the runtimepath | `lua/` resolution, `package.loaded`, `runtimepath`, reload | split into modules |
| 17 | Errors: `pcall`, tracebacks, half-loaded configs | reading a Neovim Lua traceback, `:messages`, `pcall` boundaries | guarded requires |

### Phase E — The `vim.` object model (18–26) · ~24h

The heart of the course, and the thing the learner asked for most.

| # | Lesson | Teaches | Config after |
|---|--------|---------|--------------|
| 18 | Options: `vim.opt` vs `vim.o` vs `vim.go` vs `vim.bo`/`vim.wo` | the four scopes, why `vim.opt` returns an object, `:append`/`:remove` | options, correctly scoped |
| 19 | Variables: `vim.g` `vim.b` `vim.w` `vim.t` `vim.v` `vim.env` | scope prefixes, `vim.v.count`, plugin-config-by-global | — |
| 20 | `vim.cmd` | `vim.cmd('…')` vs `vim.cmd.foo{}`, escaping, when Ex still wins | — |
| 21 | `vim.fn` | calling any Vimscript function, `expand()`, filename modifiers, `%:p:h` | path helpers |
| 22 | `vim.api` | handles, 0- vs 1-indexing, buffers/windows, extmarks, `nvim_buf_*` | — |
| 23 | **Keymaps to your own functions** | `vim.keymap.set` with a Lua callback, `desc`, `expr`, buffer-local, `<Plug>` | real custom keymaps |
| 24 | Autocommands and augroups | `nvim_create_autocmd`, `clear = true`, event choice, `FileType` vs `ftplugin` | autocmds |
| 25 | User commands, `vim.notify`, `vim.ui` | `nvim_create_user_command`, `nargs`/`complete`, `vim.ui.select`/`input` | commands |
| 26 | Async: `vim.schedule`, `vim.defer_fn`, `vim.uv`, `vim.system` | the fast-event trap ("E5560"), `vim.system` over `jobstart` | async helper |

### Phase F — A config you can trust (27–29) · ~14h

| # | Lesson | Teaches | Config after |
|---|--------|---------|--------------|
| 27 | Config architecture | `init.lua` + `lua/<you>/`, load order, what must precede what, naming | full structure |
| 28 | lazy.nvim | bootstrap, `spec`, `{ import = "plugins" }`, one-file-per-plugin, lockfile | lazy.nvim installed |
| 29 | Lazy loading, and diagnosing a broken config | `event`/`ft`/`cmd`/`keys`, `opts` vs `config`, bisecting, `:checkhealth`, `--startuptime` | final config |

**Total: roughly 84 hours.** Lessons 07 (macros), 18 (option scopes) and 22
(`vim.api` indexing) are the three that reliably take longer than expected.

### Deliberately out of scope

Named here so no future session "helpfully" adds them:

- Built-in LSP beyond a survey → `appendices/f-lsp-and-plugins.md`.
- Treesitter internals, DAP, completion-engine setup → same appendix.
- Vimscript as a language. Lesson 21 teaches calling Vimscript functions through
  `vim.fn`, and lesson 20 teaches Ex commands via `vim.cmd`. Writing
  `function! Foo()` is not taught: the learner configures in Lua.
- Any "build a plugin" track. That is a different course.

---

## 4. Lesson structure

`LESSON.md` headings, exact, in order. `AUTHORING.md` explains each.

```text
# NN — <title>

<2–4 sentence advance organizer. Does not restate the title.>

## What this lesson asks of you
## <named foundation sections — as many as needed; never "Part 1">
## Worked example
## Distinctions worth keeping straight
## Common errors
## Check yourself
## Key takeaways
## Lookup (not the lesson)
```

The lesson ends by sending the reader to `TASK.md`.

`Common errors` contains **real, transcribed output**. See §6.

---

## 5. The drill contract

A drill is a Lua file returning one table, run headlessly by `tools/drill.lua`.
Three kinds, distinguished by which key is present. Full field reference in
`AUTHORING.md`; the design commitments are:

- **`keys` drills** assert on buffer text after keystrokes. This makes editor
  skill — motions, operators, macros, `:g` — machine-checkable, which no other
  Vim course this design surveyed attempts.
- The runner feeds keys with `nvim_feedkeys(…, 'mtx')`. This is load-bearing:
  `m` applies mappings (so lesson 23's drills can exercise a keymap the learner
  set), `t` marks input as typed (so `.`, undo and macro *recording* behave),
  `x` executes immediately. **`'nx'` silently breaks macro replay** — `2@q`
  becomes a no-op and a wrong answer passes. Verified, do not change.
- An empty answer reports `TODO`, not `FAIL`, so a fresh lesson reads as
  unattempted rather than broken.
- **CI runs `./drill --all-solutions` and requires every drill to PASS.** A
  solution that does not pass is a bug in the course, not in the learner.

---

## 6. Standards

### Transcribe output, never compose it

Every "Common errors" entry, every expected-output block, every quoted error
message must be pasted from a real run. Neovim's messages are specific:

```
E5108: Error executing lua .../init.lua:3: attempt to index a nil value (field 'opt')
E5560: nvim_echo must not be called in a fast event context
E121: Undefined variable: g:does_not_exist
```

An invented-but-plausible message is worse than none: when the learner's real
error does not match the book, they stop trusting the book. Produce it, then
paste it:

```bash
nvim --headless -u NONE -c 'lua <BROKEN>' -c qa 2>&1
```

### Lua code standards

- 2-space indent, no tabs. 100-column soft limit (`.stylua.toml` enforces it).
- `snake_case` for functions and locals; `M` for a module table.
- `local` everywhere. Config-level globals only via `vim.g`.
- `stylua --check .` must pass. CI enforces it.
- Comments explain **why**, not what.

### Voice

Second person. Instructor-clear, not cute, not corporate. Warm without
cheerleading — *"this one trips nearly everyone the first time"* is good;
*"this is easy!"* is forbidden, because it isn't, and it makes a stuck learner
feel stupid. Define jargon inline, one sentence, on first use.

### Accuracy commitments

- Every `:help` tag cited must exist. Verify: `nvim --headless -u NONE -c 'help <tag>' -c qa`.
- Every command shown must have been run in this environment.
- Version-specific claims name the version.

---

## 7. Verification

`./drill --all-solutions` and CI are the source of truth. CI runs:

1. `stylua --check .`
2. every `config/NN/` snapshot starts Neovim with zero errors
3. `./drill --all-solutions` — all PASS, no TODO, no BROKEN
4. every `:help` tag cited in a `## Lookup` section resolves

There are no placeholder tests. The previous attempt's `tests/` asserted that
flag variables had been set — they verified the harness, not the learner. A test
that cannot fail is worse than no test.

---

## 8. Authoring order, and the one rule that prevented the last failure

**Build in lesson order. Never front-run.**

The failure mode is: implement something interesting, then back-fill lessons that
explain it. That is how `06-capstone` ate the last attempt. Before writing any
code into a lesson, ask: *has every concept in this code already been taught?*
`vim.api` before lesson 22, a plugin before lesson 28, `pcall` before lesson 17 —
all violations. If a lesson genuinely needs a concept earlier, **move the
concept's lesson earlier and update this file**; do not smuggle it in.

Progress is tracked in `docs/STATUS.md`, which records for each lesson whether
`LESSON.md`, `TASK.md`, drills and snapshot exist. It is updated in the same
commit as the work, and it is the first thing a new session reads.
