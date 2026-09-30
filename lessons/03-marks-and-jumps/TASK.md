# 03 — Task

Practice only. The teaching is in [`LESSON.md`](LESSON.md).

Nothing in this lesson changes `~/.config/hero`.

## 1. Drills

```bash
./drill 03
```

Twenty-two drills; two are `BUG HUNT`. Several assert on the **cursor** rather
than the buffer, so their `want` equals `start` — the buffer is meant to come back
unchanged, and `want_cursor` is the real assertion. If you see a buffer diff on
one of those, your keys modified text they should not have.

Pairs to read side by side: 01 and 02 (the two mark spellings), 03 and 04 (the same
pair used as operator targets), 12 and 13 (one and two steps back through the
changelist).

Drill 22's comment is worth reading even after you solve it: the wrong answer
lands on the right line by coincidence in the simpler version of that scenario,
which is why the mistake survives in people's habits.

**Done when** `./drill 03` reports no `TODO` and no `FAIL`.

## 2. Build the habit that pays

Open a file in `hero` that is at least 200 lines long — one of your own plugin
files, or `:e $VIMRUNTIME/doc/motion.txt` if you want something long to hand.

Do each of these until it is automatic:

- `G`, read the bottom, `` `` `` back.
- `gg`, read the top, `` `` `` back.
- Search for something, `<C-o>` back, `<C-i>` forward again.
- Edit three separate places, wander off, then `g;` `g;` `g;` through them.
- Set `mA` in one file, open another, `` `A `` back.

The test is not whether you can do them. It is whether you reach for them without
deciding to. Notice each time you were about to scroll instead.

## 3. Read your own lists

With the file open and some navigating done:

```vim
:jumps
:marks
:changes
```

For each one, answer before you look anything up:

1. Where is the `>` in `:jumps`, and how many `<C-o>` presses would reach the
   oldest entry shown?
2. In `:marks`, find one row where the last column is a **file name** rather than
   line text. Which kind of mark is that, and why is that column different?
3. `:changes` numbers its newest entry `0`, but `:jumps` numbers its nearest entry
   `1`. Check both, and note which of `g;` and `<C-o>` therefore needs no count to
   reach the most recent item.

## 4. Prove the jump list to yourself

The lesson claims `:25` is not a jump and `25G` is. Do not take it on trust.

```vim
:clearjumps
:25
:jumps
```

then

```vim
:clearjumps
25G
:jumps
```

Then find the sentence in `:h jump-motions` that predicts both results, and check
whether `:s` is on that list. It is — which means "Ex commands are never jumps" is
the wrong generalization to draw.

## 5. Find the edge where marks go stale

1. Set `ma` on a line. Delete that line with `dd`. Press `` `a ``. What happened,
   and which sentence in `:h jump-motions` covers it?
2. Set `ma` on line 20. Insert five lines *above* it. Press `` `a ``. Did the mark
   follow the text, or stay on line 20? Explain what that tells you about what a
   mark actually stores.
3. Set `mA`, quit Neovim entirely, restart, and press `` `A ``. Did it survive?
   Now look at `:h 'shada'` and find which marks are persisted.

Question 2 is the one that changes how you use marks, so do not skip it.

## 6. Write two drills

Add `exercises/23-mine-*.lua` and `exercises/24-mine-*.lua`:

1. One that asserts on `want_cursor` only — the buffer must come back unchanged.
   Use it to pin down a behavior you got wrong in step 5.
2. One `BUG HUNT` where the wrong answer uses `` `a `` in place of `'a` or the
   reverse, in a scenario where the two genuinely differ. Drill 21 is the model;
   make yours a different operator.

Confirm the first fails with a blank answer, and that the second's failure message
would tell you what to look at.
