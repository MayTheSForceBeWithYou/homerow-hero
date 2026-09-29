# AUTHORING.md — how to write a homerow-hero lesson

`DESIGN.md` says *what* the course covers. This says *how* a lesson is written
well enough to keep.

**Canonical depth bar: `lessons/00-second-config/LESSON.md`.** When a lesson feels
thin, raise it toward that bar. Do not raise `TASK.md` into a second lecture.

---

## Split of responsibilities

| File | Job |
|---|---|
| `LESSON.md` | **Teach.** Advance organizer, foundations, worked example, distinctions, common errors, check, takeaways. |
| `TASK.md` | **Practice only.** What to run, what to implement, how you know you are done. |
| `exercises/` | Drills with the answer blanked. The learner's tree. |
| `solutions/` | Reference answers, filenames mirrored. Must all PASS. |
| `:help`, `appendices/` | **Lookup.** Flag spelling, tag names, field names. **Not the teacher.** |

If a `TASK.md` says "read `:h text-objects`" as the *way to learn* text objects,
that task is wrong. Teach it in `LESSON.md`; list the tag under **Lookup**.

---

## The template (headings exact, in order)

```text
# NN — <title>

<2–4 sentence advance organizer. Do not restate the title. Say what the reader
will be able to do, and name the one idea the lesson turns on.>

## What this lesson asks of you
## <named foundation sections — as many as needed>
## Worked example
## Distinctions worth keeping straight
## Common errors
## Check yourself
## Key takeaways
## Lookup (not the lesson)
```

- **Never** name a section "Part 1" / "Section 2". Name it after its content.
- End by sending the reader to `TASK.md`.
- `## Distinctions worth keeping straight` is a table or definition list of pairs
  that get confused: `vim.o` vs `vim.opt`, buffer vs window, `:h 'list'` vs
  `:h :list`, yank register vs unnamed register.

---

## Depth rules (LESSON side) — load-bearing

These exist because the first attempt at this repo pointed at `:help` without
teaching the reader how to *see* what Neovim showed them. Fix that in
`LESSON.md`, not in chat, and not by pasting help files.

1. **If you tell the reader to "note" or "find" something, teach the recognition
   rule.** Bad: *"note the buffer number."* Good: name the column, show a real
   `:ls` line, and say which token is the number, which is the flag block, and
   which is the name.

2. **Decode multi-field output field by field.** Whenever `:ls`, `:map`,
   `:verbose set`, `:checkhealth`, `:Lazy profile`, `vim.inspect` or a traceback
   prints several fields on one line, add a table or bullet list saying what each
   field *is*. Show a real line from this environment first.

   ```
     2 %a + "lua/hero/init.lua"        line 14
     │ │  │ └ name                     └ cursor line
     │ │  └ modified
     │ └ %=current window, a=active
     └ buffer number
   ```

3. **Give a navigation move before interpretation.** Prefer *"search for
   `mapleader`"*, *"put the cursor on `shiftwidth` and press `K`"*, *"scroll to
   the `## keys` heading"* over *"look at the output"*. Readers drown in a
   400-line `:checkhealth` when you skip the anchor.

4. **Name the rejected wrong reading next to the tricky artifact.** Every worked
   example includes, as a paragraph and not a heading, the mistake a competent
   beginner makes here. Real ones for this course:
   - reading `vim.opt.x = y` as if it were plain assignment to a table field
   - thinking `vim.o.shiftwidth` and `vim.bo.shiftwidth` are the same knob
   - reading a `:ls` flag block as part of the filename
   - believing `<leader>` is stored in the mapping (it is expanded at *set* time)
   - assuming `nvim_win_get_cursor` returns the same indexing as `nvim_buf_get_lines`
   - thinking `require('x')` re-runs `x` on every call

5. **Prose carries every load-bearing fact.** Fenced blocks are fine, but a
   skimmer who reads only prose must still learn the mechanism. A fact that
   exists only inside a code comment is not taught.

6. **Keep `:help` under Lookup.** The lesson teaches what to look for and how to
   recognize it. `:help` supplies spelling afterward. Never paste a help page.

7. **Hand-holding belongs in `LESSON.md`; restraint belongs in `TASK.md`.** If
   learners stall because the *lesson* omitted a recognition rule, fix the
   lesson — do not compensate by pasting lecture prose into `TASK.md`.

---

## Common errors — transcribed, never composed

Make the mistake, run it, paste what Neovim actually said. Generators:

```bash
# Lua error from a config line
nvim --headless -u NONE -c 'lua vim.opt.nosuchoption = 1' -c qa 2>&1

# Error from sourcing a file
printf 'vim.opt.shiftwidth = "four"\n' > /tmp/t.lua
nvim --headless -u NONE -c 'luafile /tmp/t.lua' -c qa 2>&1

# Ex command error
nvim --headless -u NONE -c 'set nosuchoption' -c qa 2>&1
```

Each entry gets: the verbatim message, what it actually means, and the fix.
Format:

```markdown
### `E5108: Error executing lua …: attempt to index a nil value (field 'opt')`

You wrote `vim.opt` as `vim.Opt`. …
```

---

## Drill contract

A drill is a Lua file returning **one table**. Filenames: `NN-slug.lua`, and
`solutions/NN-slug.lua` mirrors `exercises/NN-slug.lua` exactly.

### Every drill

| Field | Type | Meaning |
|---|---|---|
| `goal` | string, **required** | One line, imperative. Shown next to PASS/TODO. |
| `hint` | string | Shown only on FAIL. Nudge, never the answer. |

### `keys` drills — editor skill

| Field | Type | Meaning |
|---|---|---|
| `start` | list of strings, **required** | Buffer contents before. |
| `cursor` | `{line, col}` | 1-based line, **0-based col** (the `nvim_win_*` convention). Default `{1, 0}`. |
| `keys` | string, **required** | What the learner types. `''` reports TODO. `<Esc>`, `<CR>`, `<C-o>` notation works. |
| `want` | list of strings, **required** | Buffer contents after. |
| `want_cursor` | `{line, col}` | Optional cursor assertion. |
| `want_registers` | `{ [name] = string }` | Optional register assertion. |
| `want_mode` | string | Optional; `nvim_get_mode().mode` short form, e.g. `'i'`, `'v'`. |
| `filetype` | string | Sets `vim.bo.filetype` before typing — for `it`/`at` or comment drills. |
| `setup` | function | Runs after the buffer exists, before keys. Use for a keymap the drill exercises. |

```lua
-- exercises/04-inner-quote.lua
return {
  goal = 'Replace only the text between the quotes with bye',
  start = { 'say "hi there" now' },
  cursor = { 1, 0 },
  want = { 'say "bye" now' },
  hint = 'One text object does this without counting characters.',
  keys = '', -- <- your answer
}
```

### `value` drills — does your expression produce the right thing

| Field | Meaning |
|---|---|
| `run` | function; its return value is deep-compared |
| `value` | the expected value. `run()` returning `nil` reports TODO. |

```lua
return {
  goal = 'Return the absolute path of the config directory',
  run = function()
    return nil -- <- your answer
  end,
  value = vim.fn.stdpath('config'),
}
```

### Marking the answer, for `tools/derive-exercises.sh`

Exercises are generated from solutions by blanking the answer, so a drill's `goal`,
`start` and `want` cannot drift from the answer that satisfies them. Mark the answer
in one of four ways:

| In the solution | Becomes in the exercise |
|---|---|
| `keys = '...'` | `keys = '',` |
| `local answer = X -- <- your answer` | `local answer = nil -- <- your answer` |
| `return X -- <- your answer` | `return nil -- <- your answer` |
| any statement + `-- <- your answer` | the statement is removed |
| `-- ANSWER_BEGIN` … `-- ANSWER_END` | the whole block becomes `local answer = nil` |

**Prefer the block form for anything longer than one line.** A table literal or a
multi-statement answer needs it, and so does anything stylua might wrap — a line-end
marker left on a wrapped fragment silently produces a broken exercise.

A `check` drill with no `answer` variable cannot tell "unattempted" from "wrong", so
also place a bare `-- TODO_GUARD` comment where the learner's code belongs. It is an
inert comment in the solution and becomes `error('DRILL_TODO')` in the exercise, so
the drill reports TODO until the learner deletes it.

### `check` drills — free-form assertions

| Field | Meaning |
|---|---|
| `check` | function; must not error. `assert(cond, 'message')` inside. |

Raise an error containing `DRILL_TODO` to report TODO instead of FAIL.

### What the runner isolates for you, and what it does not

All drills run in **one** Neovim session, so global state leaks forward. The runner
resets the worst of it before every drill:

- **every option**, snapshotted at `scope = 'global'`. Note the scope: `expandtab`
  and `shiftwidth` are *buffer*-scoped but have a global default that new buffers
  inherit, and `vim.opt.expandtab = true` sets that default.
- **the writable registers** it can name, including the unnamed, numbered, small
  delete and the letters drills use.
- **`mapleader` and `maplocalleader`.**

A `keys` drill also gets a fresh scratch buffer, so buffer- and window-local options
need no help.

What it does **not** reset: marks (including global `A`–`Z`), the jumplist and
changelist, autocommands, user commands, and keymaps you install outside `setup`. If
a drill depends on any of those, seed it in `setup`.

This exists because the failure mode is far too quiet to leave to authors
remembering. Lesson 04's drills set `expandtab`, which broke a lesson 06 drill that
expected the `-u NONE` default — and only when the whole suite ran, never when lesson
06 ran alone. Verify order-independence when you add a lesson:

```bash
./drill --all-solutions                                  # forward
./drill $(ls -d lessons/*/solutions | tac | tr '\n' ' ')  # reverse
```

### Rules for drills

- **Drills verify one idea.** If a failure could have two causes, split it.
- **`hint` never contains the answer.** *"One text object does this"* — yes.
  *"Use `ci\"`"* — no.
- **A `keys` drill's `want` must be reachable by the lesson's taught keys.** Do
  not require a motion the learner has not met.
- **Twenty-plus drills per editor-skill lesson**, including at least two
  "BUG HUNT" drills where a wrong answer is pre-filled and must be diagnosed.
- **Every solution must PASS.** Run `./drill NN --solutions` before committing.

---

## Check yourself

Questions answerable **from the lesson alone**. At least one must check a
recognition rule (a column, a flag block, an indexing convention), not only
vocabulary. If the only way to answer is to have memorized a help page, the
lesson failed.

Answers go in a collapsed block:

```markdown
<details><summary>Answers</summary>

1. …

</details>
```

## Key takeaways

Three to six defensible claims. Not a restatement of the headings.

## Lookup (not the lesson)

Only tags that exist. Verify each:

```bash
nvim --headless -u NONE -c 'help vim.keymap.set()' -c qa && echo ok
```

Cite tags the way the learner must type them, and say so when the quoting
matters — `:h 'shiftwidth'` (option, quoted) is a different tag from
`:h shiftwidth`, and `:h vim.fn` differs from `:h vim.fn.expand()`.

---

## Revision checklist

Run this over any lesson you touch.

- [ ] Every "note / find / inspect" sentence has a recognition rule beside it
- [ ] Multi-field output is decoded field by field
- [ ] A navigation anchor precedes every busy listing
- [ ] At least one rejected wrong reading, matching a real beginner mix-up
- [ ] Every load-bearing fact appears in prose, not only in a code fence
- [ ] `Common errors` output is transcribed from a real run
- [ ] Every `:help` tag cited resolves
- [ ] `TASK.md` stayed practice-only
- [ ] Every solution drill PASSes; no drill can pass without checking anything
- [ ] Nothing used that a later lesson teaches (`DESIGN.md` §8)
- [ ] No capstone framing, no "and at the end you'll have built X"
- [ ] `docs/STATUS.md` updated in the same commit
