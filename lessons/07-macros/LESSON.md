# 07 — Macros and the dot formula

A macro is a recording of your keystrokes, replayed on demand. That much is easy.
What separates a macro that saves you ten minutes from one that mangles your file
on the fourth line is a small set of habits about *where each repetition starts*
and *what happens when one fails*. This lesson is mostly those habits, because the
recording part takes one paragraph.

## What this lesson asks of you

Record an edit once and apply it to fifty lines with confidence — meaning you can
say in advance where it will stop and why.

No config work. Nothing is added to `~/.config/hero`.

## First, the thing that is not a macro

`.` repeats the last **change**. Not the last keystroke, not the last motion — the
last thing that modified the buffer.

```
"a b c d e"   dw..       -> "d e"          three words, one change repeated twice
"x" / "y"     A;<Esc>j.  -> "x;" / "y;"    appended, moved, repeated
"aa bb cc"    ciwZ<Esc>w. -> "Z Z cc"      changed, moved, repeated
```

Notice the shape of the second and third: **one keystroke to move, one keystroke to
repeat.** That pairing is worth naming, because when you can arrange an edit that
way you do not need a macro at all:

- `A;<Esc>` then `j.` `j.` `j.`
- `ciwZ<Esc>` then `w.` `w.` `w.`

The habit is to design the change so that a single motion lands you where the next
one belongs. `.` is cheaper than a macro, it needs no register, and you can watch
each repetition happen. Reach for a macro when the repeated unit needs *more than
one* change, or when the movement between repetitions is itself complicated.

## Recording and replaying

```
q{register}     start recording into that register
q               stop recording
@{register}     replay it
@@              replay whatever you replayed last
{count}@{reg}   replay it count times
```

Measured:

```
"1"/"2"/"3"        qqI-<Esc>jq  then @q    -> "-1" "-2" "3"
"1".."5"           qqI-<Esc>jq  then 3@q   -> "-1" "-2" "-3" "-4" "5"
"1"/"2"/"3"        qqI-<Esc>jq  then @q@@  -> "-1" "-2" "-3"
```

The recording itself performs the edit, which is why `@q` in the first line
produced *two* changed lines and not one. Your recording pass is the first
repetition; a count of `3` afterwards gives you four in total.

## A macro *is* a register

This is not an analogy. `q{letter}` writes keystrokes into the same register
`"{letter}` that lesson 05 used for text, and `@` executes a register's contents as
keys. Everything from lesson 05 applies.

```
after recording into w:  getreg("w") = "I-\27j"
```

That `\27` is a literal Escape byte. In a buffer it displays as `^[`.

Three things follow, and they are the reason this lesson comes after registers:

**You can write a macro without recording it.** `setreg` takes a string:

```
setreg('z', 'A!\27j')  then  3@z   ->  "p!" "q!" "r!"
```

**You can look at a macro.** `"qp` pastes it into the buffer as text:

```
"qp   ->   A;^[j
```

**You can edit a macro.** Paste it, fix the text, and yank it back:

```
"qp        paste the macro onto a line
           edit the text like any other text
0"qy$      from column 1, yank to end-of-line back into q
```

The `0` matters — `"qy$` from wherever the cursor happens to be yanks only the
tail. This is the everyday fix for "my macro is almost right", and it beats
re-recording a fifteen-keystroke sequence to change one character.

## Habit one: anchor every repetition

Here is the failure that makes people distrust macros. Delete the character after
each semicolon, down a column of lines:

```
setreg q = 'f;xj'      3@q on "a;b" / "c;d" / "e;f"
                       ->  "ab"  "c;d"  "e;f"
```

One line worked. The other two were untouched, silently.

The reason is not the macro and not a bug. After `x` on line 1 the cursor sits at
column 1. `j` moves down to column 1 of line 2 — which is exactly where the `;`
is. And `f` searches **strictly forward**, so from *on* the semicolon there is no
semicolon ahead. The motion fails, and a failed motion aborts the macro.

Add one keystroke to the front:

```
setreg q = '0f;xj'     3@q  ->  "ab"  "cd"  "ef"
```

`0` returns to column 1 before doing anything else, so every repetition starts from
the same known place rather than from wherever the previous one happened to leave
the cursor.

**The rule: begin a macro by establishing position, not by assuming it.**

But be precise about which keystrokes need that help, or you will cargo-cult a `0`
onto everything. The distinction is **absolute** versus **relative**:

| Absolute — self-anchoring | Relative — inherits the cursor |
|---|---|
| `0` `^` `$` `I` `A` `G` `gg` | `f` `t` `F` `T` `w` `e` `b` `h` `l` |
| text objects (`ciw`, `di(`) | counted motions (`3w`, `2f,`) |

`I` goes to the first non-blank and `A` to the end of the line *whatever column you
were in*, so a macro built from them needs no anchor. Measured — the same macro with
and without a leading `0`:

```
"I'<Esc>A',<Esc>j"    ->  "'alpha',"  "'beta',"  "'gamma',"
"0I'<Esc>A',<Esc>j"   ->  "'alpha',"  "'beta',"  "'gamma',"
```

Identical. The `0` is harmless and does nothing.

`f` is the opposite, and it is why the example above broke. Prefer the absolute
keys and text objects where you can; anchor explicitly when you cannot.

**The wrong reading to reject.** The intuitive diagnosis of the broken version is
"the macro only ran once", which suggests the replay mechanism failed. It ran three
times; the second attempt aborted on its first keystroke, and the third never
started. Nothing is broken — the macro was written to depend on a column it did not
set. Distinguishing "did not run" from "ran and aborted" is the whole diagnostic
skill here, and `:registers` plus the cursor's final position is how you tell.

## Habit two: a failure aborts the macro — use it

A failed motion or a failed command stops the macro immediately, and stops any
remaining count with it.

Measured, `0f;xj` over five lines where the fourth has no semicolon:

```
99@w   ->  "a" "b" "c" "no" "d;"        cursor ends at line 4
```

Three lines processed, then the fourth aborted and the remaining ninety-six
repetitions were discarded. Line 5 was never reached.

That is a feature, and it produces the most useful habit in this lesson:
**do not count your lines. Use an absurd count.** `99@q` or `500@q` runs until
something stops it — the end of the file, or a line that does not match. You never
have to know how many lines there are, and a macro that would corrupt line 40
stops there instead of continuing.

### When you want it to survive the gap instead

Sometimes a line that does not match should be skipped rather than treated as a
stopping point. A substitution with the `e` flag does not fail when it finds
nothing:

```
setreg q = ':s/;//e<CR>j'   3@q on "a;b" / "no-semi" / "c;d"
                            ->  "ab"  "no-semi"  "cd"
```

All three lines were visited. Without the `e` flag the same macro aborts at the
gap:

```
setreg q = ':s/;//<CR>j'    ->  "ab"  "no-semi"  "c;d"
```

So you have a choice, and it is a real design decision rather than a trick: an
aborting macro is a safety net, and `:s///e` is how you opt out of it when the
non-matching lines are expected. `:h :s_flags` documents `e`.

## Recursive macros

A macro can call itself, which makes "until it fails" the loop condition.

```
setreg r = ''            the register must be EMPTY first
qr  I-<Esc>j  @r  q      record, ending with a call to itself
@r                       then invoke it once to start
```

Measured on four lines: after recording, only line 1 has changed — because the `@r`
inside the recording ran an empty register, which does nothing. Invoking `@r`
afterwards processes the rest:

```
after recording only : { "-1", "2", "3", "4" }
after invoking @r    : { "-1", "-2", "-3", "-4" }
```

Two requirements, and both are easy to forget: **clear the register first**, so the
`@r` you record is a no-op rather than an old macro; and **invoke it afterwards**,
because recording is not running.

Recursion is elegant and `99@q` is usually enough. Prefer the count; keep recursion
for when you genuinely cannot bound the repetitions.

## Worked example

You have a list of names and you need each one quoted and comma-terminated:

```
alpha          ->      'alpha',
beta                   'beta',
gamma                  'gamma',
```

**Design the repetition before recording.** The unit of work is one line, and the
next unit is the line below — so the macro must end by moving down, and every
keystroke in between must be one that does not care where the cursor starts.

```
qq          record into q
I'<Esc>     insert the opening quote -- absolute: first non-blank
A',<Esc>    append the closing quote and comma -- absolute: end of line
j           move to the next line
q           stop
```

Test it *once* on the next line — `@q` — and look. If it is right:

```
99@q
```

and it stops at the end of the file. You never counted the names.

**The wrong reading to reject.** Having just learned to anchor, the reflex is to put
a `0` at the front of this macro too. It is not wrong, but it is not doing anything
either: `I` and `A` are absolute, so this macro is already position-independent.
Measured, the two versions produce identical output. Anchoring is not a ritual to
perform on every macro — it is the fix for a *specific* dependency, which you can
see by asking of each keystroke: "does this do the same thing from any column?" For
`I`, `A`, `$`, `G` and text objects the answer is yes. For `f`, `t`, `w` and
counted motions it is no, and those are the ones that need `0`.

Here is that failure with the columns arranged to expose it — append `!` after the
first comma, where the commas are at *decreasing* columns:

```
"f,a!<Esc>j"    ->  "aaa,!bbb"  "a,bbbbb"   "aa,bbbb"     aborted at line 2
"0f,a!<Esc>j"   ->  "aaa,!bbb"  "a,!bbbbb"  "aa,!bbbb"    all three
```

Repetition one left the cursor at column 4. Line 2's comma is at column 1, behind
it, and `f` only searches forward.

Then notice something. This particular job needs no macro at all:

```
I'<Esc>A',<Esc>      on the first line
j0.                  ...does not work -- `.` repeats only ONE change
```

Two changes per line means `.` cannot do it, and that is precisely the boundary
between the dot formula and a macro. One change per repetition: use `.`. More than
one: record it.

## Distinctions worth keeping straight

| These look alike | but |
|---|---|
| `.` / `@q` | one change repeated / any number of keystrokes replayed |
| `q` to start / `q` to stop | same key; the second one ends the recording |
| `@q` / `@@` | that register / whatever you replayed last |
| recording / replaying | the recording pass **performs** the edit, so it counts as repetition one |
| `"q` / `@q` | the same register, as text / executed as keys |
| `f;xj` / `0f;xj` | depends on the previous cursor column / anchors first |
| relative keys / absolute keys | `f` `t` `w` inherit the cursor / `I` `A` `$` `G` do not, so they need no anchor |
| macro aborts / macro "did not run" | it ran and stopped; the cursor shows where |
| `:s/x//` / `:s/x//e` | fails on no match, aborting the macro / succeeds silently |
| `3@q` / `99@q` | you counted the lines / you let the abort decide |
| recursive `@r` while recording / after | a no-op on an empty register / the actual loop |

## Common errors

### The macro ran once and the rest of the lines are untouched

It aborted on the second repetition. Almost always the column: the macro assumed a
position the previous repetition left it in. Anchor with `0` or `^` as the first
keystroke. Check where the cursor ended up — that is the line it failed on.

### The macro worked for three lines and then stopped

Same mechanism, and this time it is probably correct behavior: line four did not
match. Decide whether you want it to stop there (leave it) or skip that line
(`:s///e`).

### `@q` does nothing at all

The register is empty or holds text rather than keys. `:registers q` shows the
contents; a macro looks like keystrokes with `^[` for Escape.

### Your macro pasted text instead of executing

`"qp` puts the register's contents into the buffer; `@q` executes them. Both are
useful — the first is how you inspect and edit a macro.

### Recording seemed to do nothing, then everything happened twice

The recording pass performs the edit as you type it. So `qq …edit… q` then `3@q`
applies the edit four times in total, not three.

### A recursive macro did nothing after you recorded it

Recording is not running — invoke `@r` once afterwards. And if it ran away doing
the wrong thing, you forgot to clear the register first, so the `@r` you recorded
called an older macro.

### You cannot remember which register you recorded into

`:registers` lists them all; macros are visibly keystrokes. Pick a habit — many
people always use `q` for throwaway macros, which is why `qq` … `q` … `@q` is the
most common spelling you will see.

## Check yourself

1. What exactly does `.` repeat, and why can it not do two changes per line?
2. You record with `qq…q` and then press `3@q`. How many times has the edit been
   applied in total?
3. `f;xj` processed one line out of five and stopped. Give the cause and the
   one-character fix.
4. Why is `99@q` better practice than counting the lines and typing `17@q`?
5. Your macro must visit lines that do not contain the pattern. What changes?
6. Give the two steps people forget with a recursive macro.
7. How do you fix one wrong keystroke in the middle of a twenty-keystroke macro
   without re-recording it?
8. A macro is in register `q`. What is the difference between `"qp` and `@q`?

<details><summary>Answers</summary>

1. The last change — the last buffer modification, not the last keystroke. Two
   changes per line means the second one is the "last change", so `.` repeats only
   that half.
2. Four. The recording pass performed the edit once, and the count adds three.
3. After the first repetition the cursor sat on the target character, and `f`
   searches strictly forward, so the motion failed and a failed motion aborts the
   macro. Prefix the macro with `0`.
4. Because the abort stops it: `99@q` runs until the end of the file or until a
   line does not match. You never have to know the count, and a macro that would
   go wrong on line 18 stops there rather than continuing to line 17's neighbours.
5. Make the failing command not fail — a substitution with the `e` flag,
   `:s/pat//e`, succeeds silently when there is no match, so the macro continues.
6. Clear the register before recording, so the recursive call is a no-op; and
   invoke `@r` once after recording, because recording is not running.
7. Paste it out with `"qp`, edit the text, then yank it back with `0"qy$`.
8. `"qp` puts the register's contents into the buffer as text; `@q` executes them
   as keystrokes.

</details>

## Key takeaways

- `.` repeats the last change. Design edits as one change plus one motion and you
  often need no macro; two changes per repetition is the boundary where you do.
- A macro is a register. You can inspect it with `"qp`, write it with `setreg`, and
  fix it by pasting, editing, and yanking back with `0"qy$`.
- Anchor a macro when it uses a *relative* keystroke (`f`, `t`, `w`, a counted
  motion). `I`, `A`, `$`, `G` and text objects are absolute and need no anchor —
  which is the reason to prefer them.
- A failure aborts the macro and discards the remaining count. That is a safety
  net: use `99@q` instead of counting, and let it stop where it should.
- When non-matching lines are expected rather than exceptional, `:s/pat//e` opts out
  of the abort.
- The recording pass performs the edit, so it is repetition one.

## Lookup (not the lesson)

| Tag | For |
|---|---|
| `:h q` | recording, and `:h recording` for the concept |
| `:h @` | replaying, and `:h @@` |
| `:h .` | the redo command, and `:h redo-register` |
| `:h complex-repeat` | the whole chapter on macros |
| `:h registers` | where macros live — the same registers as lesson 05 |
| `:h :s_flags` | the `e` flag that stops a substitution from failing |
| `:h setreg()` | writing a macro without recording it |
| `:h :normal` | running keystrokes from an Ex command — lesson 09 builds on this |

Now go to [`TASK.md`](TASK.md).
