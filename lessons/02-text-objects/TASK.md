# 02 — Task

Practice only. The teaching is in [`LESSON.md`](LESSON.md).

Nothing in this lesson changes `~/.config/hero`.

## 1. Drills

```bash
./drill 02
```

Twenty-eight drills. Twenty-six start at `TODO`; two are `BUG HUNT` and start at
`FAIL` with a plausible-but-wrong answer in place.

Work them in order. Several pairs differ only in the `i`/`a` slot — 01 and 02,
09 and 10, 14 and 15, 22 and 23 — and the point of each pair is the one character
of difference in `want`. If you find yourself guessing between `i` and `a`, stop
and reread that pair's `want` values side by side.

Drills 03, 04 and 08 are the three that most people get wrong on first contact.
They are all the same fact: `iw` selects a word *or* a whitespace run.

**Done when** `./drill 02` reports no `TODO` and no `FAIL`.

## 2. Retire `f` for these edits

Open a real Lua file in `hero` — one of your own plugin specs is ideal. For the
rest of this session, forbid yourself `f`, `t` and any counting of characters when
the target is a delimited thing.

Do each of these at least three times, from a cursor placed *badly* on purpose:

- change a quoted string's contents
- change a whole quoted string including its quotes
- empty a function's argument list
- delete a nested table value, using a count rather than navigating
- rename a variable without disturbing its surrounding spaces

The habit you are building is deciding *what kind of thing* the target is before
deciding any keys.

## 3. Find the boundary where objects stop helping

Objects are not universally better and you should know where the edge is.

1. Put the cursor after the closing parenthesis of a call and press `ci(`. What
   happens, and why does the lesson call this consistent rather than a bug?
2. Find a line with two separate quoted strings. Put the cursor before the first
   and press `ci"`. Now put it between them and press `ci"` again. Explain both
   results.
3. On `foo()` — an empty argument list — try `di(` and then `ci(`. They disagree.
   Which one does `:h ib` predict, and what does the other one tell you about how
   `c` differs from `d`?
4. Construct a case where `dt,` is genuinely better than any object. (Hint: the
   target is a distance, not a thing.)

## 4. Read the definitions that the lesson compressed

```vim
:h text-objects
```

Read the opening paragraphs — specifically the sentence about what happens when an
object is used **without** an operator, and the note about Visual mode.

Then find, in `:h iw`, the sentence that explains the word-or-whitespace behavior
you drilled in 03 and 08. Write it down in your own words.

Finally, `:h cpo-M`. You do not need to change the option; you need to know it
exists, so that when a quote object mishandles an escaped quote you know where to
look instead of assuming Vim is broken.

## 5. Write two drills

Add `exercises/29-mine-*.lua` and `exercises/30-mine-*.lua`:

1. One that proves an object spans lines — pick a multi-line construct from your
   own config and assert on its contents afterwards.
2. One `BUG HUNT` in the style of 27: pre-fill an answer that is *plausible and
   wrong*, and write a `hint` that points at the distinction without naming the
   fix.

Confirm both behave correctly: the first passes only with the right answer, the
second fails informatively before you correct it.
