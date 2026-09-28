# 06 — Insert mode and completion

Most people treat Insert mode as a dumb typewriter: you go in, you type, you press
`<Esc>`. It has about fifteen commands of its own, and the ones worth knowing are
the ones that save you from leaving. This lesson also covers built-in completion,
which exists without any plugin and is the thing a completion plugin is a
front-end *for*.

## What this lesson asks of you

Fix a typo four words back, insert a register's contents, and complete a word, a
whole line and a file path — all without leaving Insert mode.

No config work. Nothing is added to `~/.config/hero`.

## Seven ways in, and they are not interchangeable

| Key | Puts the cursor |
|---|---|
| `i` | before the cursor |
| `a` | after the cursor |
| `I` | before the first **non-blank** on the line |
| `A` | at the end of the line |
| `o` | on a new line **below** |
| `O` | on a new line **above** |
| `gI` | at **column 1**, ignoring indentation |

Measured on `bc` with the cursor on `b`, and on `  bc` with the cursor on the `b`:

```
iA<Esc>   -> "Abc"
aA<Esc>   -> "bAc"
IA<Esc>   -> "  Abc"      first non-blank
gIA<Esc>  -> "A  bc"      column 1
AA<Esc>   -> "bcA"
oA<Esc>   -> "bc", "A"
OA<Esc>   -> "A", "bc"
```

`I` and `gI` are the pair to notice: `I` respects the indentation and `gI` does not.
`gI` is what you want for a label or a comment marker that must sit flush left.

And from lesson 03, `gi` — lowercase — returns you to where Insert mode was last
left, *and* re-enters it. `gI` and `gi` differ by one shift key and do unrelated
things.

## Editing without leaving

These are the reason to stop pressing `<Esc>` for every correction.

| Key | Does |
|---|---|
| `<C-w>` | delete the word before the cursor |
| `<C-u>` | delete back to where this insertion started |
| `<C-h>` | backspace (same as `<BS>`, works everywhere) |
| `<C-r>{reg}` | insert a register's contents |
| `<C-o>{cmd}` | run **one** Normal-mode command, then come straight back |
| `<C-a>` | insert the text you last typed in Insert mode |
| `<C-t>` / `<C-d>` | indent / dedent the current line |
| `<C-v>{code}` | insert a character literally, or by code point |

Measured:

```
ifoo bar<C-w>END<Esc>   -> "foo END"        <C-w> removed "bar"
ifoo bar<C-u>END<Esc>   -> "END"            <C-u> removed the whole insertion
iabc<C-h>Z<Esc>         -> "abZ"
yiw o<C-r>0<Esc>        -> "HI", "HI"       <C-r>0 inserted the yank register
A!<C-o>0START<Esc>      -> "STARTabc def!"  one Normal command, then back
iFOO<Esc> o<C-a><Esc>   -> "FOO", "FOO"     <C-a> repeated the last insertion
i<C-t>Z<Esc>            -> "\tZ"            indented from inside Insert
i<C-v>u0041<Esc>        -> "A"              code point 0041
```

Two of these deserve a second look.

**`<C-o>` is the escape hatch that is not `<Esc>`.** It runs exactly one Normal
command and returns you to Insert mode where you were. In the measurement above,
`<C-o>0` jumped to column 1, typed `START`, and the `!` typed earlier was still at
the end — the insertion was never interrupted. Use it for a single `d`, a `p`, a
jump, or a `zz` to recentre.

**`<C-u>` deletes back to the start of *this insertion*, not the start of the
line.** That is `'backspace'` behaving as configured — the default is
`indent,eol,start`, which is what allows `<C-u>` and `<C-h>` to cross the point
where you entered Insert mode at all. With `backspace` unset, neither can, and
that is why very old Vim configurations feel obstructive.

## Completion, with no plugin involved

Press `<C-n>` in Insert mode and Neovim completes the word you are typing from
words it can already see. `<C-p>` is the same, searching backwards.

Measured, with `alphabetical` on line 1 and `al` on line 2:

```
A<C-n><Esc>   -> "alphabetical"
```

Where it looks is the `'complete'` option. The default here:

```
complete = ".,w,b,u,t"
```

Each letter is a source, tried in order:

| Flag | Source |
|---|---|
| `.` | the current buffer |
| `w` | other **w**indows' buffers |
| `b` | loaded **b**uffers in the buffer list |
| `u` | **u**nloaded buffers in the buffer list |
| `t` | **t**ags |

So out of the box, completion already reaches every file you have open. That is
usually enough to make `<C-n>` worth the keystroke on any long identifier.

With more than one candidate, a popup menu appears and `<C-n>` cycles forward,
`<C-p>` back. Neovim reports its position in the corner:

```
alpha / album / al  ->  A<C-n>      "match 1 of 4"  -> alpha
                        A<C-n><C-n> "match 2 of 4"  -> album
```

### The `<C-x>` submodes complete something other than a word

`<C-x>` opens a second keystroke that chooses *what* to complete:

| Keys | Completes |
|---|---|
| `<C-x><C-f>` | a **file** path |
| `<C-x><C-l>` | a whole **line** |
| `<C-x><C-o>` | **omni** completion (filetype-aware; what an LSP plugs into) |
| `<C-x><C-]>` | a tag |

Two measured, and they are the two that earn their keystrokes:

```
"fcomp/tar"  A<C-x><C-f>  -> "fcomp/target_file.txt"
"  fu"       A<C-x><C-l>  -> "  full line here"
```

`<C-x><C-f>` completes paths relative to the working directory, which makes typing
a `require` path or a filename in a terminal command genuinely quick.
`<C-x><C-l>` is for when you need a near-duplicate of a line that already exists.

### The trap: `<C-e>` and `<C-y>` mean two different things

This is the part of Insert mode that silently misbehaves, and it is worth the
paragraph.

**With no popup open**, these copy a character from the adjacent line:

```
"ABCDEF" above, cursor on "x"    A<C-y><C-y><Esc>  -> "xBC"   copied from ABOVE
"ABCDEF" below, cursor on "x"    A<C-e><C-e><Esc>  -> "xBC"   copied from BELOW
```

**With a popup open**, they control the popup instead:

```
"al" with a match    A<C-n><C-y><Esc>  -> "alphabetical"   <C-y> ACCEPTED
                     A<C-n><C-e><Esc>  -> "al"             <C-e> CANCELLED
```

Same keys, unrelated jobs, decided by whether the menu happens to be visible.
`:h popupmenu-keys` is the authority for the popup meanings.

**The wrong reading to reject.** When `<C-e>` "randomly deletes my completion",
the conclusion people draw is that completion is flaky. It is not — `<C-e>` is
doing exactly its documented job, which is to cancel. The mnemonic that keeps them
straight: with the menu up, **`<C-y>` = *yes*, `<C-e>` = *escape***. Away from the
menu they are the "copy from the line below/above" pair, which you will rarely
reach for deliberately.

`'completeopt'` controls the menu's behavior. Default here:

```
completeopt = "menu,popup"
```

`menu` shows the popup, `popup` puts extra information in a floating window. The
flag people add is `noselect`, which shows the menu without pre-selecting the
first entry — so `<CR>` inserts a newline rather than accepting a completion you
did not choose.

## Replace mode

`R` enters Replace mode, where typing overwrites instead of inserting:

```
"abcdef"  RXY<Esc>  ->  "XYcdef"
```

`r{char}` is the single-character version and does not enter a mode at all. Replace
mode is narrow but occasionally exactly right — fixed-width tables, ASCII diagrams.

## Worked example

You are typing a line of Lua and you notice a mistake several words back, then you
need a long identifier and a file path.

```lua
vim.keymap.set('n', '<leader>x', require('hero.commmands').run)
```

The typo is `commmands`. You are still in Insert mode at the end of the line.

The instinct is `<Esc>`, navigate, fix, `A`, continue. That loses your place and
costs a mode round trip. Instead:

```
<C-w><C-w>                        delete back over `.run)` and `commmands')`
                                  (two words; <C-w> stops at punctuation)
```

which is fine but blunt. Better, because it does not retype anything correct:

```
<C-o>                             one Normal command coming
  ?commm<CR>                      search back to the typo
<C-o>                             and another
  ciwcommands<Esc>                fix it
A                                 back to the end
```

Better still, and the point of the lesson: **do not type the identifier by hand at
all.** If `hero.commands` appears anywhere in any open buffer, `<C-n>` after
`comm` completes it correctly, and the typo never happens. If the file exists on
disk, `<C-x><C-f>` after `hero/` completes the path.

**The wrong reading to reject.** It is tempting to read this list as "memorise
fifteen control keys". The useful takeaway is narrower: there are exactly three
situations worth a keystroke you do not already know — you need a word that exists
somewhere (`<C-n>`), you need a path (`<C-x><C-f>`), or you need one Normal command
without leaving (`<C-o>`). Those three cover nearly everything. The rest of the
table is there so that when you press `<C-e>` by accident you know what happened.

## Distinctions worth keeping straight

| These look alike | but |
|---|---|
| `i` / `a` | before / after the cursor |
| `I` / `gI` | first non-blank / column 1, ignoring indent |
| `gI` / `gi` | column 1 on this line / back to where Insert mode last ended, resuming |
| `<C-h>` / `<C-w>` / `<C-u>` | one character / one word / the whole insertion |
| `<C-u>` / `d0` | back to where insertion started / back to column 1 |
| `<C-o>` / `<Esc>` | one Normal command, then back / leave Insert mode |
| `<C-a>` / `<C-r>.` | both insert the last-typed text; `<C-r>.` names the register |
| `<C-e>` popup up / popup down | cancel the completion / copy the character below |
| `<C-y>` popup up / popup down | accept the completion / copy the character above |
| `<C-n>` / `<C-x><C-l>` | complete a word / complete a whole line |
| `R` / `r` | Replace mode until `<Esc>` / one character, no mode change |
| `'complete'` / `'completeopt'` | *where* matches come from / *how* the menu behaves |

## Common errors

### `<C-w>` in Insert mode did nothing, or closed a window

You were in Normal mode, where `<C-w>` is the window prefix. In Insert mode it
deletes a word; outside it, it waits for a window command.

### `<C-u>` deleted less than you expected

It deletes back to where the current insertion began, not to column 1. If you
entered Insert mode mid-line, that is the boundary. `'backspace'` must include
`start` for it to cross that point at all; the default `indent,eol,start` does.

### Your completion vanished when you pressed `<C-e>`

`<C-e>` cancels an open popup — documented behavior, not a glitch. `<C-y>` accepts.
Remember *yes* and *escape*.

### `<CR>` accepted a completion you had not chosen

The first match was pre-selected, so `<CR>` confirmed it. Add `noselect` to
`'completeopt'` if you want the menu to appear with nothing selected.

### `<C-x><C-f>` completes paths from the wrong place

It is relative to Neovim's working directory, not to the file you are editing.
Check with `:pwd`.

### `<C-n>` finds nothing in a file full of the word

Check `'complete'`. If it has been narrowed — some configs set it to `.` only —
completion stops looking at other buffers.

### Pasting into the terminal produced cascading indentation

Your terminal sent the text as individual keystrokes and every autoindent applied.
This is what `'paste'` historically existed for; modern terminals and Neovim
negotiate bracketed paste instead, so prefer `"+p` from Normal mode over a terminal
paste into Insert mode.

## Check yourself

1. Give the two keys that enter Insert mode at column 1 and at the first non-blank,
   and say which respects indentation.
2. You are deep in Insert mode and need to delete the last three words. One key,
   pressed three times — which?
3. You need to recentre the screen without leaving Insert mode. How?
4. `<C-y>` did two completely different things on two consecutive occasions.
   Explain.
5. Which option decides *where* `<C-n>` looks, and what does its default `.,w,b,u,t`
   mean?
6. You want to complete a file path. Which keys?
7. Why does `<C-u>` sometimes leave text on the line that you expected it to remove?
8. What is the difference between `<C-a>` and `<C-r>.`?

<details><summary>Answers</summary>

1. `gI` enters at column 1; `I` enters at the first non-blank. `I` respects
   indentation, `gI` ignores it.
2. `<C-w>`.
3. `<C-o>zz` — `<C-o>` runs one Normal command and returns you to Insert mode.
4. A completion popup was open one time and not the other. With the popup up,
   `<C-y>` accepts the selected match; with no popup, it copies the character from
   the line above.
5. `'complete'`. The flags mean: `.` current buffer, `w` other windows' buffers,
   `b` loaded buffers in the buffer list, `u` unloaded buffers in that list, `t`
   tags.
6. `<C-x><C-f>`.
7. It deletes back to where *this insertion* started, not to the start of the line.
   If you entered Insert mode mid-line, everything before that point stays.
8. Nothing functional — both insert the last-typed text. `<C-r>.` is the general
   "insert a register" form naming the `.` register; `<C-a>` is a dedicated key for
   the same thing.

</details>

## Key takeaways

- Insert mode has its own commands. The three that pay for themselves are `<C-n>`
  (complete a word that exists), `<C-x><C-f>` (complete a path), and `<C-o>` (one
  Normal command without leaving).
- `<C-w>` and `<C-u>` delete a word and the whole insertion; `<C-u>`'s boundary is
  where the insertion began, which `'backspace'` governs.
- Completion is built in and already searches every open buffer, because
  `'complete'` defaults to `.,w,b,u,t`. A completion plugin is a front-end for this.
- `<C-e>` and `<C-y>` have two unrelated meanings depending on whether a popup is
  open. With the menu up: `<C-y>` is yes, `<C-e>` is escape.
- `I` and `gI` differ on indentation; `gI` and `gi` are unrelated commands one shift
  key apart.

## Lookup (not the lesson)

| Tag | For |
|---|---|
| `:h Insert-mode` | the whole mode, and `:h insert.txt` for the chapter |
| `:h i_CTRL-W` | and `:h i_CTRL-U`, `:h i_CTRL-H` — the deletion keys |
| `:h i_CTRL-O` | one Normal command from Insert mode |
| `:h i_CTRL-R` | inserting a register, and `:h i_CTRL-A` |
| `:h i_CTRL-T` | and `:h i_CTRL-D` — indent and dedent |
| `:h i_CTRL-V_digit` | inserting by code point |
| `:h ins-completion` | the whole completion chapter |
| `:h compl-keyword` | what `<C-n>` searches |
| `:h i_CTRL-X_CTRL-F` | and `:h i_CTRL-X_CTRL-L`, `:h i_CTRL-X_CTRL-O` |
| `:h popupmenu-keys` | the popup meanings of `<C-e>` and `<C-y>` |
| `:h 'complete'` | and `:h 'completeopt'` — note the quotes |
| `:h 'backspace'` | why `<C-u>` can cross the insertion point |
| `:h Replace-mode` | `R` |
| `:h gI` | and `:h gi` — the two that look alike |

Now go to [`TASK.md`](TASK.md).
