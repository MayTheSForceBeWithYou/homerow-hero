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
| 04 | first-init-lua | — | — | — | — |
| 05 | registers | — | — | — | — |
| 06 | insert-mode | — | — | — | n/a |
| 07 | macros | — | — | — | n/a |
| 08 | ex-ranges-substitute | — | — | — | n/a |
| 09 | global-and-normal | — | — | — | n/a |
| 10 | buffers-windows-tabs | — | — | — | — |
| 11 | search-and-quickfix | — | — | — | — |
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

- Next lesson to author: **04 — your first `init.lua`.** It is the first lesson
  since 00 that changes the config, so it produces `config/04`. Phase A closes
  there.
- Authoring order that works: write `solutions/` first with the answer on one
  marked line, run `./drill NN --solutions` until green, then
  `bash tools/derive-exercises.sh NN`. BUG HUNT drills are hand-authored in
  `exercises/` and skipped by the tool. Finish with
  `bash tools/check-drill-specs.sh`.
- The drill runner has now caught five wrong author expectations, every one of
  them either whitespace or a coincidence. Verify buffer contents with `%q`, and
  when writing a BUG HUNT **check that the wrong answer actually fails** — lesson
  03's drill 22 first passed by accident, because the last jump happened to start
  on the line of the last edit.
- Corrections already folded into prose, do not reintroduce:
  - `-u NONE` has `'expandtab'` off, so `>>` inserts a tab (01).
  - `dw` / `daW` on a line's last word or WORD leave or take the *preceding*
    whitespace, since an operator only reaches forward from the cursor (01, 02).
  - Block and quote text objects **do** search forward on the line; `:h ib` says
    so. They never search backwards (02).
  - A mark follows its text when lines shift; it is cleared only when its own line
    is deleted, and reads as `{ 0, 0 }` from Lua afterwards (03).
  - `:25` is not a jump command but `25G` is, verified through both typed keys and
    `vim.cmd`. `:s` and `:tag` *are* jumps, so "Ex commands are never jumps" is
    the wrong generalization (03).
