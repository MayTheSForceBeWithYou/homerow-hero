# 09 — Task

Practice only. The teaching is in [`LESSON.md`](LESSON.md).

Nothing in this lesson changes `~/.config/hero`. This is the last lesson of Phase B.

## 1. Drills

```bash
./drill 09
```

Twenty-one drills; two are `BUG HUNT`.

Drills 16 and 17 produce the same buffer by two different routes — one relies on
`:g` ignoring errors, the other puts the requirement into the pattern. The lesson
argues for the second. Do both, then decide whether you agree.

Drill 20 asserts on a **register**, not just the buffer, so its failure message
looks different from the others. Read all of it.

**Done when** `./drill 09` reports no `TODO` and no `FAIL`.

## 2. Look before you act, every time

Take a real file — a log, a large config, anything with repeated structure.

For each of the following, run the `:g/pattern` form **first** with no command, read
what it lists, and only then add the command:

1. Delete every blank line. (`:g/^$/d _`)
2. Delete every line that is only whitespace. How is that pattern different from the
   one above, and which did you actually want?
3. Keep only the lines mentioning a word you choose.
4. Number every matching line by appending something to it.
5. Move every matching line to the end.

Step 2 is the one that teaches the habit: the two patterns look equivalent and are
not.

## 3. Feel the difference between a macro and `:g`

Set up a buffer where some lines match a pattern and some do not, and where the edit
*fails* on the non-matching ones.

1. Do it with a macro and a big count. Note where it stopped.
2. Do it with `:g/./normal …`. Note that it did not stop.
3. Do it with `:g/pattern/normal …`, selecting precisely.
4. Write down which of the three you would want in each of these situations:
   - a file you have never seen before
   - a file you generated yourself and know the shape of
   - a command going into a script

## 4. Combine it with a macro

1. Record a macro that edits **one line** and does *not* move to another line — no
   trailing `j`.
2. Apply it with `:g/pattern/normal @q`.
3. Now record the equivalent standalone macro *with* the `j` and a big count, and
   compare the two. Which was easier to write? Which would you trust on a file
   where the matching lines are scattered?

## 5. Read the mechanism

```vim
:h :global
```

Find and answer:

1. The paragraph describing the two scans. Why does that design mean deleting
   matching lines never skips one?
2. What is the default `[cmd]`?
3. What does the documentation say about `:d _`, and what two benefits does it claim?
4. Find `E147`. What is the restriction on nesting, and why does it exist?
5. What happens when the command produces an error on one line?

Then `:h :normal` and answer: what does it do if the keystrokes are incomplete, and
what does it append for you at the end?

## 6. Write one drill

Add `exercises/22-mine-*.lua` using a `:g` combination this lesson did not drill:
`:g` with `:>` to indent matching lines, `:g` with `:j` to join, `:g` driving a
`:normal` that uses a text object from lesson 02, or a `:v` restricted by a range.
Assert on the buffer, and if your command deletes anything, use `_` so the drill does
not depend on register state left by an earlier drill.
