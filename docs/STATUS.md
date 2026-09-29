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
| 12 | help-as-a-database | — | — | — | n/a |
| 13 | lua-in-neovim | — | — | — | n/a |
| 14 | tables | — | — | — | n/a |
| 15 | functions-and-closures | — | — | — | n/a |
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

- **Phases A and B are complete (lessons 00–09).** Next to author: **10 — buffers,
  windows, tabs and the argument list**, which opens Phase C and changes the config
  (window keymaps), so it produces `config/10`.
- Authoring order that works:
  1. Verify every fact headlessly first, printing buffer contents with `%q` so
     whitespace is visible. Never write prose around an unrun command.
  2. Write `solutions/` with the answer on a line marked `-- <- your answer`. For a
     drill where the learner writes a whole statement, also place a bare
     `-- TODO_GUARD` comment where their code belongs.
  3. `./drill NN --solutions` until green.
  4. `bash tools/derive-exercises.sh NN`.
  5. Hand-author BUG HUNT drills in `exercises/` (the tool skips `*bug-hunt*`), and
     **confirm the planted mistake actually fails** — two have silently passed.
  6. `stylua .`, then `bash tools/check-drill-specs.sh`.
- The drill runner has now caught eight wrong author expectations. It earns its keep
  every lesson; do not skip step 3.

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
  `I` `A` `$` `G` and text objects are absolute and need no anchor — verified
  identical output with and without a leading `0` (07).
- Pressing `:` in Visual mode already prefills `'<,'>`; typing it again yields
  `:'<,'>'<,'>s/…`, which silently does nothing (08).
- `:g` defaults to the **whole file** while `:s` defaults to the current line (09).
- A macro aborts on error; `:g` logs and continues. Documented, and the basis for
  choosing between them (07, 09).

## Harness notes

- Registers, `vim.g.mapleader`, global marks and the jumplist all persist between
  drills in one session. Clear or seed whatever a drill reads, in `setup`.
- Recording a macro through `nvim_feedkeys` injects a spurious K_SPECIAL pseudo-key
  (`80 FD 35`) after a character-argument command like `f`. It is harmless on
  replay, so drills may record such macros — only an assertion on exact register
  bytes would be affected.
- The system clipboard cannot be drilled: the provider fails here and on CI
  runners, and reading `"+` back always looks healthy. Lesson 05 verifies it as an
  interactive task instead.
