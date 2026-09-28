# 07 — Task

Practice only. The teaching is in [`LESSON.md`](LESSON.md).

Nothing in this lesson changes `~/.config/hero`.

## 1. Drills

```bash
./drill 07
```

Eighteen drills; two are `BUG HUNT`.

Two of them — 11 and 14 — ask you to produce a **failure** on purpose, because
predicting where a macro stops is the actual skill this lesson teaches. Read their
`want` values carefully before assuming they are typos.

Drills 10 and 11 are the same macro with and without its anchor, and 17 is that
distinction again as a bug hunt. If you only take one thing from this lesson, take
the anchor.

Several drills have `setup` write a macro with `setreg` instead of recording one.
That is not a shortcut around the lesson — it is the lesson's point that a macro is
just a register.

**Done when** `./drill 07` reports no `TODO` and no `FAIL`.

## 2. Build the dot habit first

Open a real file with a repetitive section. Before recording anything, look for
edits you can do with **one change and one motion**:

- append something to a run of lines → `A…<Esc>` then `j.` `j.` `j.`
- change a repeated word → `ciw…<Esc>` then `n.` or `w.`
- delete a trailing item → `$x` then `j.`

Do at least five of these. You are looking for the moment you reach for `q` on a job
`.` would have done, because that is the reflex to unlearn.

## 3. Record something you actually need

Find a genuine repetitive edit in your own files — a list to quote, imports to
reorder, log lines to trim.

1. **Design before recording.** Say out loud: what is one unit of work, and what
   motion gets me to the next one?
2. Record it, anchoring with `0` or `^` as the first keystroke.
3. Test with a single `@q` and *look at the result* before going further.
4. Then `99@q`.
5. Note where it stopped and whether that was the right place.

Step 3 is the one people skip and then need `u` several times.

## 4. Make a macro fail on purpose, and read the evidence

1. Write a macro that depends on a character being present, with no anchor.
2. Run it with a big count over a buffer where the third line does not match.
3. Before looking: predict which line the cursor will end on.
4. Check. Then answer: how would you tell "the macro ran and aborted" apart from
   "the macro never ran"?
5. Now add the `e` flag version and confirm it walks past the gap instead.

## 5. Fix a macro without re-recording it

1. Record a macro of at least eight keystrokes with one deliberate mistake.
2. `"qp` to paste it into the buffer. Note that Escape shows as `^[`.
3. Edit the text to fix the mistake.
4. `0"qy$` to yank it back into `q`.
5. Run it and confirm the fix.

The `0` in step 4 is load-bearing. Try it once without, and see what you get.

## 6. Read the flag that changes the design

```vim
:h :s_flags
```

Find `e`. Then answer: is an aborting macro a bug or a feature? Give one situation
where you want the abort and one where you want `e`, from your own files.

## 7. Write one drill

Add `exercises/19-mine-*.lua` for a macro behavior this lesson did not drill:
`@:` (repeat the last Ex command), a macro that operates on a visual selection, or
one that uses a named register for text *and* another for the macro at the same
time. Have `setup` clear or seed whatever registers it depends on, since registers
survive between drills.
