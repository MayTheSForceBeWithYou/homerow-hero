# 03 — Marks, jumps, and getting back

Lessons 01 and 02 changed text near the cursor. This one is about the cursor
itself: leaving a position deliberately so you can return to it, and returning to
positions you never thought to save. Neovim keeps three separate histories for
this — marks, the jumplist and the changelist — and the reason people bounce
around a file inefficiently is usually that they know about the first and not the
other two.

## What this lesson asks of you

Move away from a place in a file and come back to it without looking, and know
which of the three mechanisms answers a given "where was I?" question.

No config work. Nothing is added to `~/.config/hero`.

## Marks you set yourself

`m{letter}` records the cursor's position. Nothing visible happens; there is no
message and no sign in the gutter.

Two commands return to it, and the difference is the same exclusive/inclusive-shaped
distinction that ran through lesson 01:

- `` `a `` — jump to the **exact position**: line *and* column.
- `'a` — jump to the **line**, landing on its first non-blank character.

Measured, with a mark set at line 3, column 5, then jumping from elsewhere:

```
set global mark F at f1.txt {3,4}
after `F        f1.txt {3,4}   exact position, column preserved
after 'F        f1.txt {3,0}   line only, column = first non-blank
```

The mnemonic: the backtick is a thin, precise character, so it gets you a precise
position. The apostrophe is what Vim uses everywhere for line-addressing.

### Lowercase marks are per-buffer; uppercase marks are global

`ma` in one file and `ma` in another are two different marks. They do not collide,
and they do not let you jump between files. Measured:

```
f2 mark a = { 3, 0 }
f1 mark a = { 2, 0 }   independent
```

`mA` through `mZ` are **global**: the mark remembers the file as well as the
position, and jumping to it *switches buffers*. This is the mechanism for "I am
going to be working between these two places for the next twenty minutes".

```
set global mark F at f1.txt {3,4}
moved to        f2.txt {1,0}
after `F        f1.txt {3,4}    the jump changed files
```

**The wrong reading to reject.** Because `ma` is silent and `` `a `` just works,
people assume marks are scoped to "the session" and are surprised when `` `a ``
lands somewhere unrelated after they switch files — they set `a` in the other
buffer an hour ago and forgot. Nothing is broken. Use lowercase for a
throwaway "back in a second" within one file, and uppercase when the file matters.
A mark that was never set reports plainly:

```
`z -> E20: Mark not set
```

### Marks are operator targets, and the two spellings differ in kind

This is the part that repays the lesson. A mark is a motion, so it composes with
every operator from lesson 01 — and because `'a` is line-addressed while `` `a ``
is position-addressed, the two produce **linewise** and **charwise** operations
respectively.

On `aaa` / `bbb` / `ccc` / `ddd` with a mark set at line 3, operating from line 1:

```
d'a  -> "ddd"                 linewise: lines 1 through 3, entire
d`a  -> "acc", "ddd"          charwise: from the cursor to the mark's column
```

Look at the second result. Line 1 kept its first character and line 3 kept its
last two, and the remains were joined. That is a charwise delete spanning lines —
the same shape as `d}` in lesson 01.

So "delete from here to that mark" has two answers and you have to mean one of
them. `d'a` is what you want for whole lines; `` d`a `` is what you want when the
column is significant.

## Marks Neovim sets for you

These are free, and they are the ones that save the most time because they answer
questions you did not plan for.

| Mark | Where it points |
|---|---|
| `` `` `` / `''` | the position **before the latest jump** |
| `` `. `` | the position of the **last change** |
| `` `^ `` | where Insert mode was **last left** |
| `` `[ `` / `` `] `` | first / last character of the **last changed or yanked** text |
| `` `< `` / `` `> `` | start / end of the **last Visual selection** |
| `` `" `` | where you were when you **last left this buffer** |

`` `` `` is the one to learn first, because it toggles. Press it twice and you are
back where you started:

```
at 5G        cursor={5,0}
after ``     cursor={2,0}    back to where the jump started
after `` again cursor={5,0}  and back again
```

That toggle is the answer to "jump to the end of the file, check something, resume"
— `G`, read, `` `` ``.

`` `. `` answers "where did I just edit?" after you have wandered off. Measured
after changing a word on line 4 and then moving to line 12:

```
after `. (last change) cursor={4,0}
after `^ (last insert) cursor={4,3}
```

Note that the two differ by column: `` `. `` is where the change *was*, `` `^ ``
is where the cursor *was when you pressed `<Esc>`*. `gi` is worth knowing here
too — it jumps to `` `^ `` **and re-enters Insert mode**, which is "resume typing
exactly where I stopped".

### Reading `:marks`, field by field

```
mark line  col file/text
 '     12    0 mu twelve
 a      3    0 gamma three
 b      9    0 iota nine
 "      1    0 alpha one
 [      1    0 alpha one
 ]     12    0 mu twelve
```

Four columns:

- **mark** — the letter or symbol you would type after `` ` `` or `'`.
- **line**, **col** — the position. `col` is 0-based here.
- **file/text** — for a mark in the current buffer, the *text of that line*, as a
  reminder of what is there. For a global mark pointing elsewhere, this column is
  the **file name** instead. The header says `file/text` because it is genuinely
  one or the other, and that is the field people misread.

One value in this family will look alarming when you inspect marks from Lua:

```
'[ = { 1, 0 }   '] = { 1, 2147483647 }
```

`2147483647` is not a corrupt column. It is `v:maxcol` — Neovim's "end of line,
whatever length that is" sentinel, used when a mark covers a whole line. You will
see it again in `'<`/`'>` after a linewise Visual selection.

## The jumplist

Neovim records every *jump* you make, per window, and `<C-o>` / `<C-i>` walk
backwards and forwards through that history. This is the browser back button, and
it is the single highest-value thing in this lesson.

```
after gg then G  cursor={12,0}
after <C-o>      cursor={1,0}
after <C-i>      cursor={12,0}
```

### Not every movement is a jump

This is the crux, and guessing wrongly is why `<C-o>` sometimes "doesn't go where
I expected". `:h jump-motions` gives the closed list verbatim:

> The following commands are "jump" commands: `'`, `` ` ``, `G`, `/`, `?`, `n`,
> `N`, `%`, `(`, `)`, `[[`, `]]`, `{`, `}`, `:s`, `:tag`, `L`, `M`, `H` and the
> commands that start editing a new file.

So `j`, `k`, `w`, `$`, `h`, `l` are **movements** — they do not touch the
jumplist, which is exactly what you want, or `<C-o>` would be useless. Measured
from line 20 of a 40-line buffer:

| Pressed | Landed | Jumplist entry? |
|---|---|---|
| `j`, `5j`, `k`, `w`, `$` | nearby | no — movement |
| `G` | 40 | **yes** |
| `gg` | 1 | **yes** |
| `{` / `}` | 1 / 40 | **yes** |
| `H` / `M` / `L` | 1 / 11 / 22 | **yes** |
| `/NEEDLE<CR>` crossing lines | 30 | **yes** |
| `%` on a real bracket pair | matching bracket | **yes** |
| `25G` | 25 | **yes** |

Two results from that table are worth keeping, because both look like exceptions
and neither is:

**A search that lands on the same line adds nothing.** Searching for a word that
occurs on the current line moved the cursor from column 0 to column 4 and left the
jumplist empty. The list is about lines — the doc's own definition is "a command
that normally moves the cursor *several lines* away".

**`:25` is not a jump, but `25G` is.** Verified two independent ways — through
typed keys and through `vim.cmd` with no typeahead involved:

```
feedkeys ":25<CR>"       line=25 entries=0
vim.cmd("25")            line=25 entries=0
feedkeys "25G"           line=25 entries=1
vim.cmd("normal! 25G")   line=25 entries=1
```

Read the documented list again and you will see why: `G` is on it, and a bare
`:{number}` is not. `:s` and `:tag` *are* on it, so it is not "Ex commands never
count". If you navigate by `:42<CR>` out of habit, `<C-o>` will not bring you
back — `42G` is the keystroke that preserves your trail.

A **failed** motion adds nothing either, which follows from lesson 01: `%` with no
bracket on the line does not move, so there is nothing to record.

### Reading `:jumps`, field by field

```
 jump line  col file/text
   4     3    0 gamma three
   3     9    0 iota nine
   2     1    0 alpha one
   1    12    0 mu twelve
>
```

- **jump** — how many `<C-o>` presses away this entry is. `1` is one press back.
- **line**, **col**, **file/text** — as in `:marks`.
- The bare **`>`** on its own line is *you*. It marks your position within the
  list. Here it is below every entry, meaning you are at the newest end and have
  not pressed `<C-o>` yet. Press `<C-o>` twice and the `>` moves up two rows.

The recognition rule: read the `>` first. Everything above it is reachable with
`<C-o>`, everything below it with `<C-i>`. Miss the `>` and the list is just
numbers.

`:clearjumps` empties it for the current window, which is mostly useful when you
want a clean trail before starting a focused edit.

## The changelist

Different question, different list. The jumplist remembers where you *looked*;
the changelist remembers where you *edited*.

`g;` goes back through your own changes, `g,` forward. After changing line 2 and
then line 5, and moving to the top:

```
at gg      {1,6}
after g;   {5,8}   the latest change
after g;   {2,7}   the older change
after g,   {5,8}   forward again
```

`:changes` prints it in the same shape as `:jumps`, `>` included:

```
change line  col text
    1     2    7 bbb two!
>   0     5    8 eee five?
```

Note the `0` row: the changelist counts the most recent change as `0`, unlike the
jumplist which starts at `1`. `g;` from a fresh position takes you to it.

`g;` is what you want after "I fixed three things in three places, now let me
check them all". `<C-o>` would walk you through *searches*, which is a different
trail entirely.

## Worked example

You are editing a Neovim config. You are at the bottom of `lua/plugins/nvim-dap.lua`
adding a keymap, and you need to check the leader key set in
`lua/hero/options.lua`, then come back and keep typing.

The naive route is to note the line number, open the other file, look, reopen the
first file, and navigate back — four decisions, one of which you will get wrong.

The route this lesson gives you:

1. `mD` — a **global** mark, because you are about to change files.
2. Open the other file however you like, and read what you came for.
3. `` `D `` — back to the exact position, file switch included.
4. `gi` — re-enter Insert mode exactly where you left it.

Steps 1 and 3 are two keystrokes each, and step 4 is the one people do not know
exists.

**The wrong reading to reject.** The instinct is to use `<C-o>` for step 3, since
"it goes back". It does — but it goes back through your *jump* history, and opening
a file is itself a jump, so `<C-o>` lands you at wherever you were when the second
file opened, and pressing it again may take you somewhere in the second file
rather than the first. `<C-o>` is for retracing an unplanned path. A mark is for a
position you *decided* mattered. Using the jumplist where a mark belongs is the
most common version of "I got lost coming back".

There is a fallback worth knowing for when you did not set a mark: `` `" `` takes
you to where you were when you last left a buffer. It is set automatically, so it
costs nothing and it is often good enough.

## Distinctions worth keeping straight

| These look alike | but |
|---|---|
| `` `a `` / `'a` | exact position, column included / the line, at first non-blank |
| `` d`a `` / `d'a` | charwise across lines / linewise, whole lines |
| `ma` / `mA` | buffer-local, does not cross files / global, switches files |
| jumplist / changelist | where you *looked* / where you *edited* |
| `<C-o>` / `g;` | back through jumps / back through your own changes |
| `<C-i>` / `<Tab>` | the same key at a terminal — which is why rebinding `<Tab>` can cost you `<C-i>` |
| `` `` `` / `` `. `` | before the last jump / at the last change |
| `` `^ `` / `gi` | jump to where Insert ended / jump there *and* resume inserting |
| `25G` / `:25` | both move to line 25; only `25G` records a jump |
| `:jumps` `>` row / an entry | the `>` is your position in the list, not a location |
| col in `:marks` / col in `vim.api` | both 0-based here; `2147483647` means "end of line" |

## Common errors

### `E20: Mark not set`

You jumped to a mark you never set in *this* buffer. Lowercase marks are
per-buffer, so a mark set in another file is not visible here. `:marks` lists
what actually exists.

### `<C-o>` seemed to work for "back to my last edit", then stopped working

This is the trap that makes the jumplist look like the changelist. If your most
recent jump happened to *start* from the line you last edited, `<C-o>` lands on
that edit and appears to be the right tool. Insert one more jump — glance at the
end of the file — and the illusion breaks:

```
2GA!<Esc>5GA?<Esc>gg<C-o>    -> {5,2}   looks correct
2GA!<Esc>5GA?<Esc>Ggg<C-o>   -> {6,1}   the same command, now wrong
2GA!<Esc>5GA?<Esc>Gggg;      -> {5,2}   g; is correct in both
```

The edits are not in the jumplist at all. They never were.

### `<C-o>` took you somewhere you have never been

You are walking a trail that includes searches, `G`s and file openings you have
forgotten making. Read `:jumps` and find the `>`; everything above it is where
`<C-o>` will go, in order. If you wanted "where I last edited", that is `g;`.

### `<C-o>` did nothing after you navigated with `:42`

`:{number}` is not a jump command. Use `42G`. Verified above, two ways.

### You rebound `<Tab>` and lost `<C-i>`

At a terminal these are the same byte. A mapping on `<Tab>` in Normal mode takes
`<C-i>` with it, and forward-jumping stops working. This is why configs that map
`<Tab>` for buffer switching so often come with a complaint about the jumplist.

### A mark stopped working after you edited the file

`:h jump-motions` is explicit that a remembered position is valid *"unless the
line containing that position was changed or deleted"*.

Be precise about what that does and does not mean, because the obvious reading is
wrong. A mark is **not** a frozen line number — it follows its text. Set a mark on
line 20, insert five lines above it, and the mark moves to line 25 and still lands
on the same text:

```
mark a before                        = { 20, 0 }
mark a after 5 lines inserted above  = { 25, 0 }
`a lands on: "line 20"
```

What breaks a mark is deleting **the marked line itself**. The mark is then cleared
outright rather than left pointing somewhere plausible:

```
mark a after dd = { 0, 0 }
`a -> E20: Mark not set
```

`{ 0, 0 }` is how a cleared mark reads from Lua, and it is why `E20` can appear for
a mark you are certain you set: you set it, and then you deleted its line.

## Check yourself

1. You set a mark at line 10, column 6, then jump away. Give the resulting cursor
   position for `` `a `` and for `'a`.
2. Why do `` d`a `` and `d'a` produce different *kinds* of deletion, and which is
   linewise?
3. You want to jump between two files for the next twenty minutes. Which register
   of marks, and why not the other?
4. You pressed `G`, read the bottom of the file, and want to resume. Two
   keystrokes.
5. You fixed three unrelated lines, wandered off, and want to review all three.
   Which command — and why is `<C-o>` the wrong tool?
6. In `:jumps` output, what is the bare `>` line, and what does its position tell
   you?
7. `2147483647` appears as a column when you read `'>` from Lua. What is it?
8. Name a movement that does *not* create a jumplist entry, and explain why that
   is desirable.
9. You navigate with `:120<CR>` and then press `<C-o>`. What happens, and what
   should you have typed?

<details><summary>Answers</summary>

1. `` `a `` lands at line 10, column 6. `'a` lands at line 10 on the first
   non-blank character, so the column is wherever the indentation ends.
2. `` `a `` addresses a position, so the operator works charwise between two
   positions and joins the remains. `'a` addresses a line, so the operation is
   linewise and takes whole lines. `d'a` is the linewise one.
3. Uppercase, `mA`–`mZ`. They store the file as well as the position, so jumping
   switches buffers. Lowercase marks are per-buffer and cannot cross files.
4. `` `` `` — the mark for "before the latest jump". `G` was a jump, so the
   position you left is recorded automatically.
5. `g;`, the changelist. `<C-o>` walks the *jumplist* — searches, `G`s and file
   openings — which is a different trail and probably does not include the three
   places you edited at all.
6. It is your own position within the list. Entries above it are reachable with
   `<C-o>`, entries below with `<C-i>`. Here it sits below everything, meaning you
   are at the newest end and have not gone back yet.
7. `v:maxcol` — the "end of line, whatever its length" sentinel. It is what a mark
   uses when it covers a whole line, not a corrupt value.
8. `j`, `k`, `w`, `$`, `h`, `l` — any of them. Desirable because the jumplist
   would otherwise fill with every ordinary cursor step and `<C-o>` would move you
   one character at a time instead of back to a meaningful place.
9. Nothing useful — `:{number}` is not on the documented jump list, so no entry
   was recorded and `<C-o>` goes to whatever older jump is there instead. `120G`
   is the keystroke that records the position you left.

</details>

## Key takeaways

- The backtick spelling of a mark is a position; the apostrophe spelling is a
  line. That distinction decides whether an operator on the mark is charwise or
  linewise.
- Lowercase marks are per-buffer, uppercase marks carry the file and switch to it.
- Neovim sets marks for you for free. `` `` `` toggles to before the last jump,
  `` `. `` is the last change, and `gi` resumes Insert where you stopped.
- Three histories answer three different questions: marks are positions you chose,
  the jumplist is where you looked, the changelist is where you edited.
- The jump list is a closed, documented set of commands. `j`/`k`/`w` are not on it,
  and neither is `:{number}` — `25G` records a jump where `:25` does not.
- In `:jumps` and `:changes`, find the `>` before reading anything else; it is
  your position in the list, and without it the rows have no direction.
- A mark follows its text when lines shift around it. It is cleared only when its
  own line is deleted, which is the real source of a surprising `E20`.

## Lookup (not the lesson)

| Tag | For |
|---|---|
| `:h mark-motions` | the mark commands, and the linewise/charwise split |
| `:h marks` | what marks are, and the automatic ones |
| `:h 'a` | and `` :h `a `` — the two spellings |
| `:h jump-motions` | the closed list of what counts as a jump |
| `:h jumplist` | and `:h CTRL-O`, `:h CTRL-I` |
| `:h changelist` | and `:h g;`, `:h g,` |
| `:h :marks` | and `:h :jumps`, `:h :changes` — the listing commands |
| `:h :clearjumps` | emptying the list for a window |
| `:h v:maxcol` | the `2147483647` sentinel |
| `:h 'shada'` | which marks survive restarting Neovim |
| `:h E20` | the error, if you want the one-line version |

Now go to [`TASK.md`](TASK.md).
