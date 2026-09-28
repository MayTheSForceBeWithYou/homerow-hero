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
| 02 | text-objects | — | — | — | n/a |
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

- Next lesson to author: **02 — text objects.** It is the natural pair to 01, and
  lesson 01's drill 24 and the `daw` aside in its prose both point forward to it.
- Lesson 01 has no config snapshot by design; the first snapshot after `config/00`
  is lesson 04.
- Two facts were corrected during authoring by the drill runner catching the
  author's own wrong expectations, both now in the lesson prose: under `-u NONE`
  `'expandtab'` is off so `>>` inserts a tab, not spaces; and `dw` on a line's
  last word leaves the *preceding* space, because an operator only reaches text
  from the cursor forward. Keep verifying whitespace with `%q`, not by eye.
