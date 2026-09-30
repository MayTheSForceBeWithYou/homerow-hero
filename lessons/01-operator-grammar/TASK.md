# 01 — Task

Practice only. The teaching is in [`LESSON.md`](LESSON.md).

Nothing in this lesson changes `~/.config/hero`.

## 1. Drills

```bash
./drill 01
```

Twenty-four drills. Twenty-two start at `TODO`; fill in the `keys` field in each
`lessons/01-operator-grammar/exercises/*.lua` and re-run. Two are marked
`BUG HUNT` and start at `FAIL` with a wrong keystroke already in place — change
one letter, do not rewrite them.

Work them in order: 01 and 02 are the same text with results that differ by one
character, and 23 and 24 are those two facts again in disguise.

When a drill fails, read the `got` / `want` block before touching the keys. The
runner prints buffer contents one line per row with the line number dimmed, and
`want` values containing whitespace at the end are quoted in the drill's comment
for exactly that reason.

**Done when** `./drill 01` reports no `TODO` and no `FAIL`.

## 2. Predict before you press

This is the habit the lesson exists to build, and drills alone will not build it.

Open any real source file in `hero`. Put the cursor somewhere in the middle of a
line. Before each keystroke sequence below, say out loud — or write down — which
characters will change. Then press it and check. Undo with `u` each time.

```
de      dw      d$      d0
dfx     dtx     (pick an x that exists later on the line)
2dw     d2w     2d2w
dd      dj      d}
gUe     g~~     >>
```

You are looking for the ones where you were wrong. Those are the boundaries you
have not internalized. Write them down.

## 3. Read the boundary rule in the source of truth

```vim
:h exclusive
```

Then, from inside that page, reach `:h inclusive` without typing it — put the
cursor on a `|inclusive|` tag reference and press `<C-]>`. Get back with `<C-o>`.

Now answer from the page, not from the lesson: when an exclusive motion's end
position is in column 1, what does Vim do instead? (This rule is why `d}`
sometimes behaves linewise. Lesson 08 uses it.)

## 4. Make a failure happen deliberately

1. Put the cursor at the end of a line and press `dt;` where there is no `;`
   ahead. What happened to the buffer? What does that tell you about a failed
   motion?
2. Press `d`, then `<Esc>`. Then press `d`, then `5`, then `<Esc>`. Was anything
   modified in either case?
3. Press `c2w` on a line with one word left. Note what Vim does rather than
   erroring.

## 5. Write your own drill

The best test of the grammar is authoring a check for it.

Copy any drill from `exercises/` to a new file
`exercises/25-mine-<something>.lua`, and change `start`, `cursor`, `want` and
`keys` so that it tests a boundary you got wrong in step 2. Run `./drill 01` and
confirm it passes. Then break the `keys` field and confirm it fails with a
readable message.

If your drill passes with a blank `keys` field, it is not testing anything —
`want` must differ from `start`.
