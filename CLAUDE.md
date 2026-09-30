# CLAUDE.md

Persistent instructions for this repository. Read at the start of every session.
Applies to any AI assistant working here — Claude, Copilot, or otherwise.

---

## Prime directive

**This repository is a course that teaches a human Neovim and the Lua that
configures it. The human writes the config. You write the lessons.**

You will write code — every lesson has examples, drills, solutions, and most
lessons ship a config snapshot. That is required. What is forbidden is getting
ahead of the curriculum: building something interesting and then back-filling
lessons that explain it.

**There is no capstone. Never add one.** The previous attempt at this repo failed
exactly here: it shipped `06-capstone/` alongside seven directories of
placeholder scaffolding, and because the capstone was the only artifact that
looked like a goal, all effort bent toward it. Lessons became preambles to it.
If you catch yourself writing "…and at the end you will have built X", stop and
reread `DESIGN.md` §0.

---

## Authoritative files

| File | Role |
|---|---|
| `DESIGN.md` | The specification. Curriculum, environment, standards. Authoritative — where your instincts disagree, follow it. |
| `AUTHORING.md` | How a lesson is written. The depth bar and the drill contract. |
| `docs/STATUS.md` | What is actually done. Never trust memory; read it. |
| `CLAUDE.md` | This file. Behavioral rules, every turn. |

`DESIGN.md` is long. Read it fully at the start of a session, not only when stuck.

---

## Session start protocol

Before doing anything else:

1. Read `DESIGN.md`, `AUTHORING.md`, and `docs/STATUS.md`.
2. Verify status from disk, not from `STATUS.md` alone:
   ```bash
   ls lessons/ config/
   ./drill --all-solutions
   ```
   If `STATUS.md` disagrees with the filesystem, that mismatch is the first thing
   to fix.
3. `git log --oneline | head -20`.
4. Report in two or three sentences: which lesson is the last complete one, what
   the next one is, and whether anything is currently failing.
5. Then proceed.

Never assume you remember the state from a previous session.

---

## Non-negotiable rules

1. **Build in lesson order.** Lesson NN is written only after NN-1 is complete
   (`LESSON.md` + `TASK.md` + drills + solutions all PASS + snapshot if the
   lesson changes the config). Never batch lessons ahead of verification.

2. **No concept before its lesson.** Before writing any code into a lesson, ask
   whether every concept in it has already been taught. `vim.api` before lesson
   22, `pcall` before 17, a plugin before 28 — all violations. If a lesson needs a
   concept earlier, move that concept's lesson earlier and update `DESIGN.md`.
   Do not smuggle it in.

3. **Transcribe output, never compose it.** Every error message, every expected
   output block, is pasted from a real run in this environment. A plausible
   invented message is worse than none: it teaches the learner to distrust the
   course. Generators are in `AUTHORING.md`.

4. **Every solution drill must PASS.** `./drill NN --solutions` before every
   commit. A failing solution is a bug in the course.

5. **No test that cannot fail.** The previous attempt's `tests/` asserted that
   flag variables had been set — verifying the harness, not the learner. If a
   check would pass against an empty implementation, it is not a check.

6. **Never write to `~/.config/nvim`.** All practice goes to `~/.config/hero` via
   `NVIM_APPNAME=hero`. The learner's working editor is out of bounds — that
   isolation is the whole answer to "without breaking everything".

7. **Snapshots are cumulative and minimal.** `config/NN/` is `config/NN-1/` plus
   exactly that lesson's change. `diff -r` between consecutive snapshots shows
   only what the lesson taught. No drive-by refactors.

8. **Update `docs/STATUS.md` in the same commit as the work.**

9. **Commit per lesson.** `git commit -m "lesson 04: options and one keymap"`.

10. **Verify every `:help` tag you cite.**
    ```bash
    nvim --headless -u NONE -c 'help vim.keymap.set()' -c qa && echo ok
    ```

---

## Failure modes — self-check before every lesson

These are the specific ways this project goes wrong. Check explicitly.

- **Capstone gravity.** Am I framing lessons as build-up to a deliverable?
- **Scaffolding.** Am I about to write "this lesson is intentionally short" or a
  placeholder I intend to fill later? Do not. Write the lesson, or write nothing
  and say so in `STATUS.md`. The last attempt died of scaffolding.
- **Outsourcing teaching to `:help`.** Does a `TASK.md` tell the learner to read a
  help page *in order to learn* the concept? Then the lesson is incomplete.
- **Untaught recognition.** Did I write "note the buffer number" without saying
  which column it is?
- **Front-running.** Does this use anything a later lesson teaches?
- **Fabricated output.** Did I paste a real run, or write what I expected?
- **Tests that check nothing.** Would this drill pass against a blank answer?
- **Version drift.** Did I describe a pre-0.12 API as current? `vim.loop`,
  `require('lspconfig').setup`, `nvim_buf_set_option` are all legacy spellings.
- **Wrong Lua.** Did I use a 5.4 idiom? Neovim runs LuaJIT (5.1 + extensions).
  `//`, `<close>`, and 5.4 integer semantics do not exist there.
- **Real config touched.** Did anything write outside `~/.config/hero`?

---

## Verify before committing

```bash
stylua --check .            # formatting
./drill --all-solutions     # every reference answer passes
bash tools/use-snapshot.sh --verify-all   # every snapshot starts cleanly
```

---

## Environment facts you must not get wrong

- Neovim **0.12.x**. Lua inside Neovim is **LuaJIT 2.1 (Lua 5.1 + extensions)**.
- The system `lua` is 5.5 and is **not** what configs run on. Never verify a
  config idiom with `lua -e`; use `nvim --headless -u NONE -c 'lua …' -c qa`.
- WSL2 / Arch. Repo and configs live in the Linux filesystem, never `/mnt/c/…`.
- `NVIM_APPNAME=hero` redirects config, data, state and cache. Verified in
  `DESIGN.md` §1.

---

## Tone

Direct, warm, specific. Second person.

*"This one trips nearly everyone the first time"* — good.
*"This is easy!"* — never. It isn't, and it makes a stuck learner feel stupid.

Define jargon inline, one sentence, on first use: buffer, window, text object,
operator-pending, upvalue, runtimepath, extmark, fast event.

---

## When the learner wants to deviate

It is their course. But:

1. Update `DESIGN.md` with the change.
2. Say plainly which already-written lessons are now inconsistent.
3. Offer to fix them or flag them, and let the learner choose.

Never silently leave the course self-contradictory.
