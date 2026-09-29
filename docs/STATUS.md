# STATUS

What is actually written. Read this at the start of a session, then verify it
against the filesystem — `DESIGN.md` §8 and `CLAUDE.md` both require that the two
agree.

Last updated: 2026-09-28

## Legend

- **done** — written, drills pass, snapshot verified
- **—** — not started
- n/a — the lesson legitimately has no artifact of that kind

## Infrastructure

| Piece | State |
|---|---|
| `DESIGN.md` | done — curriculum settled at 30 lessons |
| `AUTHORING.md` | done — depth bar is lesson 00 |
| `CLAUDE.md` | done |
| `tools/drill.lua` + `./drill` | done — keys / value / check drills, all exercised |
| `tools/use-snapshot.sh` | done — install, `--diff`, `--verify`, `--verify-all`; refuses `~/.config/nvim` |
| `tools/derive-exercises.sh` | done — author convenience; blanks answers out of `solutions/` |
| `tools/check-drill-specs.sh` | done — exercise and solution must pose the same problem |
| Phase A (00–04) | **complete** |
| Phase B (05–09) | **complete** |
| Phase C (10–12) | **complete** |
| CI | done — stylua, snapshot verification, all solution drills |
| Appendix b (footguns) | in progress — entries added as lessons produce them |
| Appendices a, c–g | — |

## Lessons

| # | Slug | LESSON | TASK | drills | snapshot |
|---|------|--------|------|--------|----------|
| 00 | second-config | done | done | 15 | `config/00` |
| 01 | operator-grammar | done | done | 24 | n/a |
| 02 | text-objects | done | done | 28 | n/a |
| 03 | marks-and-jumps | done | done | 22 | n/a |
| 04 | first-init-lua | done | done | 19 | `config/04` |
| 05 | registers | done | done | 18 | `config/05` |
| 06 | insert-mode | done | done | 20 | n/a |
| 07 | macros | done | done | 18 | n/a |
| 08 | ex-ranges-substitute | done | done | 24 | n/a |
| 09 | global-and-normal | done | done | 21 | n/a |
| 10 | buffers-windows-tabs | done | done | 18 | `config/10` |
| 11 | search-and-quickfix | done | done | 19 | `config/11` |
| 12 | help-as-a-database | done | done | 18 | n/a |
| 13 | lua-in-neovim | done | done | 20 | n/a |
| 14 | tables | done | done | 20 | n/a |
| 15 | functions-and-closures | done | done | 20 | n/a |
| 16 | modules-and-runtimepath | — | — | — | — |
| 17 | errors-and-pcall | — | — | — | — |
| 18 | option-scopes | — | — | — | — |
| 19 | variable-scopes | — | — | — | n/a |
| 20 | vim-cmd | — | — | — | n/a |
| 21 | vim-fn | — | — | — | — |
| 22 | vim-api | — | — | — | n/a |
| 23 | keymaps-to-functions | — | — | — | — |
| 24 | autocommands | — | — | — | — |
| 25 | user-commands | — | — | — | — |
| 26 | async | — | — | — | — |
| 27 | config-architecture | — | — | — | — |
| 28 | lazy-nvim | — | — | — | — |
| 29 | lazy-loading-and-debugging | — | — | — | — |

## Notes for the next session

- **Phases A, B and C are complete (lessons 00–12).** Next to author: **13 — Lua in
  Neovim**, which opens Phase D and the Lua half of the course. It has no config
  snapshot; the next snapshot is lesson 16 (splitting into modules).
- Phase D is a different kind of authoring from A–C: the subject is Lua rather than
  keystrokes, so most drills will be `value` and `check` rather than `keys`. Lesson 13
  must establish that Neovim runs **LuaJIT (5.1 + extensions)**, not the 5.5 that
  `lua -v` reports on this machine — verify idioms with
  `nvim --headless -u NONE -c 'lua …' -c qa`, never with `lua -e`.
- Authoring order that works:
  1. Verify every fact headlessly first, printing buffer contents with `%q` so
     whitespace is visible. Never write prose around an unrun command.
  2. Write `solutions/` with the answer marked. Four forms, documented in
     `AUTHORING.md`: `keys = …`; `local answer = X -- <- your answer`;
     `return X -- <- your answer`; and `-- ANSWER_BEGIN` / `-- ANSWER_END` for a
     multi-line **value**. For a statement whose effect the check asserts on, use the
     line form plus a `-- TODO_GUARD`, or the exercise reports FAIL instead of TODO.
  3. `./drill NN --solutions` until green.
  4. `bash tools/derive-exercises.sh NN`.
  5. Hand-author BUG HUNT drills in `exercises/` (the tool skips `*bug-hunt*`), and
     **confirm the planted mistake actually fails** — three have silently passed.
  6. `stylua .`, then `bash tools/check-drill-specs.sh`.
- The drill runner has now caught eleven wrong author expectations.

## Corrections already folded into prose — do not reintroduce

- `-u NONE` has `'expandtab'` off, so `>>` inserts a tab (01, revisited in 04).
- `dw` / `daW` on a line's last word or WORD leave or take the *preceding*
  whitespace, since an operator only reaches forward from the cursor (01, 02).
- Block and quote text objects **do** search forward on the line; `:h ib` says so.
  They never search backwards (02).
- A mark follows its text when lines shift; it is cleared only when its own line is
  deleted, reading as `{ 0, 0 }` from Lua afterwards (03).
- `:25` is not a jump command but `25G` is. `:s` and `:tag` *are*, so "Ex commands
  are never jumps" is the wrong generalization (03).
- **`nvim -l` does not read the user config** — `:h initialization` says `-l` skips
  everything up to step 8. Probe a config with `-c 'lua …' -c qa`.
- Anchoring a macro is for *relative* keystrokes (`f` `t` `w`, counted motions).
  `I` `A` `$` `G` and text objects are absolute and need no anchor (07).
- Pressing `:` in Visual mode already prefills `'<,'>`; typing it again yields
  `:'<,'>'<,'>s/…`, which silently does nothing (08).
- `:g` defaults to the **whole file** while `:s` defaults to the current line (09).
- A macro aborts on error; `:g` logs and continues (07, 09).
- An unmodified empty buffer is **reused** when the next file loads into it, so two
  consecutive `:enew` calls give one buffer (10).
- `'grepprg'` is set to ripgrep by Neovim's runtime **only when ripgrep is
  installed**; the documented fallback is `grep -HIn $* /dev/null` (11).
- A `:split` **inherits a copy** of the origin window's location list (11).
- A help tag is **not** a filename: running one through `fnameescape` breaks quoted
  option tags like `'list'` (12).

## Harness notes

- Registers, `vim.g.mapleader`, global marks, the jumplist and window layout persist
  between drills. The runner resets options (at `scope = 'global'`), the writable
  registers, mapleader and the working directory. It does **not** reset marks,
  jumplists, autocommands, user commands, or splits — seed or clear those in `setup`,
  and start layout-sensitive drills with `vim.cmd('silent! only')`.
- Drill targets are resolved to absolute paths, so a drill may `:cd` into a fixture
  tree safely.
- Recording a macro through `nvim_feedkeys` injects a spurious K_SPECIAL pseudo-key
  (`80 FD 35`) after a character-argument command like `f`. Harmless on replay; only
  an assertion on exact register bytes would be affected.
- The system clipboard cannot be drilled: the provider fails here and on CI runners,
  and reading `"+` back always looks healthy (05).
- `:ls` output contains `%a`, so never pass it through `string.format`.
