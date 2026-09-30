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
| Phase D (13–17) | **complete** |
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
| 16 | modules-and-runtimepath | done | done | 18 | `config/16` |
| 17 | errors-and-pcall | done | done | 18 | `config/17` |
| 18 | option-scopes | done | done | 20 | `config/18` |
| 19 | variable-scopes | done | done | 18 | n/a |
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

- **Phases A–D are complete (lessons 00–17).** Next to author: **18 — option scopes
  (`vim.opt` / `vim.o` / `vim.go` / `vim.bo` / `vim.wo`)**, which opens Phase E — the nine
  `vim.` object-model lessons, and the part of the course the learner asked for most.
- Phase E notes:
  - Lesson 18 must resolve the debt lesson 04 deliberately left: `vim.opt` returns an
    Option *object*, not a value, and `vim.opt.x + 1` yields a table whose `_value` is
    right — appendix B entry 2 already has the measurements.
  - Lesson 22 must handle the 0- versus 1-indexing collision that lessons 14 and 10 both
    flagged forward (`nvim_buf_get_lines` is 0-based and end-exclusive;
    `nvim_win_get_cursor` returns a 1-based line with a 0-based column).
  - Lesson 23 is the one the learner named as their goal: keymaps bound to functions they
    wrote. Everything it needs is now in place — functions and closures (15), modules (16),
    guarded loading (17).
  - Lesson 26 should use the measured `E5560` fast-event example already in appendix B.
- Authoring order that works:
  1. Verify every fact headlessly first. Print buffer contents with `%q` so whitespace is
     visible, and never write prose around an unrun command.
  2. Write `solutions/` with the answer marked — four forms, in `AUTHORING.md`. Use the
     `ANSWER_BEGIN` block only for a multi-line **value**; for a statement whose effect the
     check asserts on, use the line form plus a `-- TODO_GUARD`.
  3. `./drill NN --solutions` until green.
  4. `bash tools/derive-exercises.sh NN`.
  5. Hand-author BUG HUNT drills in `exercises/` (the tool skips `*bug-hunt*`), and
     **confirm the planted mistake actually fails** — four have silently passed.
  6. `stylua .`, then `bash tools/check-drill-specs.sh` and
     `bash tools/check-exercises-unsolved.sh`.
- The drill runner has now caught fifteen wrong author expectations, including one flaky
  drill. Run a new drill thirty times before trusting it (`AUTHORING.md` has the loop).

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
