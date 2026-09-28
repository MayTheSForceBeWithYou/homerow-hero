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

- **Phase A is complete.** Next lesson to author: **05 — registers and the
  clipboard**, which opens Phase B and changes the config (a `clipboard`
  decision), so it produces `config/05`.
- Authoring order that works:
  1. Verify every fact headlessly first, printing buffer contents with `%q` so
     whitespace is visible. Never write prose around an unrun command.
  2. Write `solutions/` with the answer on a line marked `-- <- your answer`. For
     a drill where the learner writes a whole statement, also place a bare
     `-- TODO_GUARD` comment where their code belongs — inert in the solution,
     it becomes `error('DRILL_TODO')` in the exercise so the drill reports TODO
     rather than FAIL while unattempted.
  3. `./drill NN --solutions` until green.
  4. `bash tools/derive-exercises.sh NN`.
  5. Hand-author BUG HUNT drills in `exercises/` (the tool skips `*bug-hunt*`),
     and **confirm the planted mistake actually fails**.
  6. `stylua .`, then `bash tools/check-drill-specs.sh`.
- The drill runner has now caught six wrong author expectations. It earns its keep
  on every lesson; do not skip step 3.
- Corrections already folded into prose, do not reintroduce:
  - `-u NONE` has `'expandtab'` off, so `>>` inserts a tab (01, revisited in 04).
  - `dw` / `daW` on a line's last word or WORD leave or take the *preceding*
    whitespace, since an operator only reaches forward from the cursor (01, 02).
  - Block and quote text objects **do** search forward on the line; `:h ib` says
    so. They never search backwards (02).
  - A mark follows its text when lines shift; it is cleared only when its own line
    is deleted, and reads as `{ 0, 0 }` from Lua afterwards (03).
  - `:25` is not a jump command but `25G` is. `:s` and `:tag` *are*, so "Ex
    commands are never jumps" is the wrong generalization (03).
  - **`nvim -l` does not read the user config** — `:h initialization` says `-l`
    skips everything up to step 8. Probe a config with `-c 'lua …' -c qa`, never
    with `-l`. This is why `tools/use-snapshot.sh --verify` uses `-c`.
- Deliberately not used before its lesson: `CmdlineEnter` would have proved lesson
  04's missing-`<CR>` behaviour directly, but autocommands are lesson 24, so that
  drill asserts on the rhs instead and the behaviour is a BUG HUNT.
