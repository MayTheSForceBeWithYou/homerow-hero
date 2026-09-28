# STATUS

What is actually written. Read this at the start of a session, then verify it
against the filesystem — `DESIGN.md` §8 and `CLAUDE.md` both require that the two
agree.

Last updated: 2026-09-27

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
| CI | done — stylua, snapshot verification, all solution drills |
| Appendix b (footguns) | in progress — entries added as lessons produce them |
| Appendices a, c–g | — |

## Lessons

| # | Slug | LESSON | TASK | drills | snapshot |
|---|------|--------|------|--------|----------|
| 00 | second-config | done | done | 15 | `config/00` |
| 01 | operator-grammar | done | done | 24 | n/a |
| 02 | text-objects | done | done | 28 | n/a |
| 03 | marks-and-jumps | — | — | — | n/a |
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

- Next lesson to author: **03 — marks and jumps.** It completes Phase A's editor
  half; lesson 04 then opens `init.lua` and the first config snapshot since 00.
- Lessons 01–03 have no config snapshot by design. The next snapshot is `config/04`.
- The drill runner has now caught three wrong author expectations. Keep verifying
  buffer contents with `%q` rather than by eye, because every one of them was
  whitespace:
  - under `-u NONE` `'expandtab'` is off, so `>>` inserts a tab, not spaces (01);
  - `dw` on a line's last word leaves the *preceding* space, since an operator
    only reaches text from the cursor forward (01);
  - `daW` on the last WORD of a line takes the *leading* whitespace for the same
    reason, so `diW` is the object for a punctuation contrast (02).
- Lesson 02 corrected a belief worth not re-introducing: block and quote objects
  **do** search forward on the line when the cursor is not already inside one.
  `:h ib` states it outright. The search never goes backwards.
