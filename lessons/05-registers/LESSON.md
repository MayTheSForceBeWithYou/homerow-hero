# 05 — Registers and the clipboard

Everything you delete, change or yank goes into a register, and Vim has about
fifty of them. The reason this matters on day one rather than day fifty is a
specific, universal frustration: you yank a line, delete something else, press
`p`, and get the deleted text instead of what you yanked. That is not a quirk to
work around — it is a register you have not been told about.

## What this lesson asks of you

Recover a yank after a delete has "overwritten" it, delete text without disturbing
what you are carrying, and know whether your system clipboard is genuinely wired
up or only appears to be.

This lesson changes `~/.config/hero`. The reference snapshot is `config/05`.

## The unnamed register, and why it loses your yank

Every yank and every delete writes to the **unnamed register**, `""`. That is
what `p` reads by default. So the last of those operations wins, and a delete is
one of those operations.

Measured. Yank a word, then delete a line:

```
yiw          unnamed="alpha"          reg0="alpha"   reg1=""
yiw then dd  unnamed="alpha beta\n"   reg0="alpha"   reg1="alpha beta\n"
```

Read the middle column. The unnamed register was replaced by the deleted line —
but `"0` still holds `alpha`. Nothing was lost; you were reading the wrong
register.

## `"0` is the yank register, and it ignores deletes

**`"0` holds the most recent yank and nothing else.** Deletes never touch it.

So the fix for the frustration in the opening paragraph is one keystroke longer
than `p`:

```
"0p
```

That is the single most useful thing in this lesson. Learn `"0p` and the whole
"my clipboard keeps getting clobbered" experience stops happening.

## Numbered registers hold deletes, and they shift

`"1` through `"9` are a queue of **linewise** deletes, newest first. Each new one
pushes the others down. Measured, deleting three lines in a row from `L1 L2 L3 L4`:

```
3x dd    reg1="L3\n"  reg2="L2\n"  reg3="L1\n"
```

So `"1` is the most recent, and the line you deleted three deletes ago is still
sitting in `"3`. This is an undo history you can paste from — `"2p` retrieves
something you removed two deletes back, without rewinding anything else.

### Small deletes go somewhere else entirely

A delete of **less than one line** does not enter the numbered queue. It goes to
the **small delete register**, `"-`:

```
diw      unnamed="alpha"   regminus="alpha"
```

This is why `"1p` sometimes produces something surprisingly old: your recent
`diw`, `x` and `de` operations never went into `"1` at all. They are all in `"-`,
each overwriting the last.

The practical consequence: `"1` through `"9` are a reliable history of *lines* you
removed, and an unreliable one for anything smaller.

## Named registers: a–z, and A–Z appends

`"a` through `"z` are yours, and nothing writes to them unless you say so:

```
"ayy     yank this line into a
"ap      put it back
```

The capital letter is the same register in **append** mode. Measured — yank one
line into `a`, then append the next:

```
"ayy then "Ayy    rega="one\ntwo\n"
```

That is the mechanism for collecting scattered lines: walk the file appending with
`"Ayy`, then put the whole collection once with `"ap`. There is no other
comfortable way to do that.

## The black hole register: delete without carrying

`"_` discards. Writing to it keeps everything else intact. Measured — yank a line,
then delete a different line into the black hole:

```
yy then "_dd    unnamed="keep\n"    reg0="keep\n"
```

Both registers still hold the yank. `"_dd` is "delete this and do not disturb what
I am carrying", and it is the other half of the answer to the opening frustration:
`"0p` recovers after the fact, `"_d` prevents the problem.

## Read-only registers you did not fill

| Register | Holds |
|---|---|
| `".` | the text you last typed in Insert mode |
| `":` | the last Ex command you ran |
| `"%` | the current file's name |
| `"#` | the alternate file's name |
| `"/` | the last search pattern |

Measured, after typing `hello ` in Insert mode in a file called `rg.txt`:

```
regdot(last insert) = "hello "
regpercent(file)    = "rg.txt"
```

`".` is more useful than it sounds: it is how you repeat a piece of typing
somewhere `.` will not help, via `"​.p`. And `"%` is how you get the current
filename into a command line without typing it.

Note that `"%` is **empty in a scratch buffer**, because there is no file. A register
being empty is information, not a malfunction.

## The expression register: compute a value into the buffer

`"=` is not storage — it evaluates. From Insert mode, `<C-r>=` prompts for an
expression and inserts the result. Measured:

```
o<C-r>=2+3<CR><Esc>    buffer = { "x", "5" }
```

You will use this for arithmetic you do not want to leave the editor for, and in
lesson 21 for calling a `vim.fn` function and dropping its result into the text.

## A register has a *type*, and the type decides what `p` does

This is the part that explains "why did my paste land on a new line?"

Every register is charwise, linewise, or blockwise. `getregtype()` reports it:

```
after yy        getregtype="V"      linewise
after yl        getregtype="v"      charwise
after <C-v>jy   getregtype="\0221"  blockwise (a ^V byte, then the width)
```

And the type changes what `p` means:

```
yy then p (linewise) -> { "A", "B", "A" }     a new line below
yl then p (charwise) -> { "AB", "CAD" }       inserted beside the cursor
```

Same key, same register, entirely different result — decided by how the text was
*captured*, not by how you put it.

**The wrong reading to reject.** When a paste lands on its own line unexpectedly,
the instinct is that `p` and `P` are confused, and people start alternating them
hoping for the best. `p` and `P` differ only in *side* — after/below versus
before/above. Whether it is "beside" or "below" at all is the register's type. If
you want a linewise register pasted inline, the fix is to capture it charwise, or
to use `:h gp` / `:h ]p` for the indent-aware variants.

## Reading `:registers`, field by field

```
Type Name Content
  c  "0   alpha
  l  "1   delta epsilon^J
  l  "a   alpha  gamma^J
  c  "b
  c  "-   beta
  c  ".   hello
  c  "%   rg.txt
```

Three columns, and the first is the one nobody notices:

- **Type** — `c` charwise, `l` linewise, `b` blockwise. This is `getregtype()` in
  one letter, and it is what decides `p`'s behavior. Read it first.
- **Name** — the register, written the way you would type it after `"`.
- **Content** — with `^J` standing in for an embedded newline. A linewise register
  ends in `^J`; that trailing `^J` *is* the linewise-ness made visible.

`:registers` with no argument lists everything; `:registers a b 0` lists only
those. Registers that hold nothing are omitted, which is why `":` may be missing
from a listing entirely.

## The system clipboard

Two more registers reach outside Neovim:

- **`"+`** — the system clipboard. What Ctrl+V pastes in other applications.
- **`"*`** — on X11, the *primary selection* (middle-click paste). On Windows and
  macOS it is the same thing as `"+`.

Use `"+` unless you specifically want the X11 primary selection. `"+yy` copies a
line out; `"+p` pastes in.

### Making every yank go to the clipboard — and why `config/05` does not

```lua
vim.opt.clipboard = 'unnamedplus'
```

This makes the unnamed register *be* the clipboard, so plain `y` and `p` talk to
the system. It is popular and it is a real convenience.

It also means **every delete overwrites your system clipboard**, which is the
opening frustration of this lesson promoted to affect other applications. Copy a
URL in your browser, delete a line in Neovim, and the URL is gone.

`config/05` therefore leaves `clipboard` unset and adds explicit keymaps instead,
so the clipboard is something you opt into per operation. The snapshot's comments
say how to flip the decision if you prefer the convenience — this is a genuine
trade-off, not a mistake to avoid.

### Neovim does not talk to the clipboard itself

There is no clipboard code in Neovim. It shells out to a **provider**: an external
program it finds on your `PATH`. `:h clipboard-tool` lists the candidates in
priority order — `wl-copy`/`wl-paste` for Wayland, `xclip` or `xsel` for X11,
`pbcopy` on macOS, `win32yank.exe` on Windows and WSL, and others.

This is why "the clipboard doesn't work" is almost never a Neovim problem. It is a
missing or non-functioning provider.

### The WSL trap: a health check that lies

Measured on this machine, in a shell with no live WSLg session:

```
has('clipboard')         = 1     compiled-in support
has('clipboard_working') = 1     a provider was FOUND
chosen provider          = "wl-copy"
provider error           = ""
```

Every indicator says fine. Now the actual transfer:

```
"+yy
getreg("+") = "HOMEROW_HERO_CLIPBOARD_PROBE\n"      looks like it worked
getreg("*") = ""
wl-paste -> "Failed to connect to a Wayland server: No such file or directory"
```

The provider cannot connect. `WAYLAND_DISPLAY` is set to `wayland-0`, but
`/run/user/1000/wayland-0` does not exist, so `wl-copy` was selected on the
strength of the environment variable and then failed.

Two things to take from this, and they are the whole reason the section exists:

- **`has('clipboard_working')` means "a provider executable was found", not "a
  transfer succeeded".** It returned 1 here, and `provider#clipboard#Error()` was
  empty, while nothing was reaching the OS.
- **Reading `"+` back proves nothing.** Neovim keeps its own copy of what you put
  there, so `getreg('+')` returns your text whether or not the provider
  succeeded. The round trip through Neovim always looks healthy.

The only honest test is to leave Neovim: yank into `"+`, then paste into another
application — or ask the provider directly, as `wl-paste` was asked above.

On WSL specifically, if `wl-copy` is present but WSLg is not running, installing
`win32yank.exe` and letting Neovim pick that instead is the usual fix, because it
talks to Windows rather than to a Wayland socket. `:h clipboard-wsl` covers it.

## Worked example

The frustration, and three ways out. You have yanked a function signature and you
need to replace a line elsewhere with it.

```
yy          yank the signature
<move>
dd          delete the line to be replaced   <-- unnamed register is now the deleted line
p           puts the deleted line back. Nothing has changed.
```

**Recovery, after the fact:** `"0p`. The yank was never lost — `"0` still holds it.

**Prevention, one:** `"_dd` instead of `dd`. The delete goes to the black hole and
the unnamed register keeps the signature, so plain `p` works.

**Prevention, two:** `"ayy` at the start. Named registers are only written when you
name them, so nothing can clobber it and `"ap` works whenever you get there.

**The wrong reading to reject.** A fourth approach suggests itself: do the delete
first, then the yank, so ordering saves you. It works for this example and fails as
soon as the edit is not a strict two-step — a search that turns out to need a
`dw`, a typo you fix on the way. Sequencing your editing around one register is a
tax you pay forever. Naming the register, or using `"0p`, costs one keystroke once.

The habit worth building: when you yank something you will need *later* rather
than *next*, name the register.

## Distinctions worth keeping straight

| These look alike | but |
|---|---|
| `""` / `"0` | unnamed takes yanks **and** deletes; `"0` takes only yanks |
| `"1` / `"-` | linewise deletes queue in `"1`–`"9`; sub-line deletes all land in `"-` |
| `"a` / `"A` | same register; the capital **appends** instead of replacing |
| `"_d` / `d` | black hole discards, leaving other registers untouched |
| `p` / `P` | side only — after/below versus before/above |
| charwise `p` / linewise `p` | beside the cursor versus on a new line — set by the register's **type** |
| `"+` / `"*` | system clipboard / X11 primary selection (identical off X11) |
| `clipboard=unnamedplus` set / unset | every delete overwrites your OS clipboard / you opt in per operation |
| `has('clipboard')` / `has('clipboard_working')` | compiled-in support / a provider was **found** — neither means a transfer worked |
| `getreg('+')` round-trip / pasting elsewhere | proves nothing / the only honest test |

## Common errors

### `p` pasted the thing you deleted, not the thing you yanked

Both went to the unnamed register and the delete was last. Use `"0p`, which holds
the yank regardless of what you have deleted since.

### `"1p` produced something much older than your last delete

Your recent deletes were smaller than a line, so they went to `"-` and never
entered the numbered queue. `"1` still holds the last *linewise* delete.

### Your paste landed on its own line and you wanted it inline

The register is linewise — check the `Type` column in `:registers`, or
`getregtype()`. `p` versus `P` will not change this; the type was set when the
text was captured.

### `"ap` pastes far more than you expected

You appended with `"A` somewhere along the way, possibly several times. `:reg a`
shows the accumulated content.

### `"+yy` then Ctrl+V in your browser pastes something stale

The provider failed. Reading `"+` back in Neovim will not reveal this, because
Neovim keeps its own copy — `getreg('+')` returns your text either way. Ask the
provider directly (`wl-paste`, `xclip -o`) or paste into another application.

### `:checkhealth` says the clipboard is fine and it is not

`has('clipboard_working')` and `provider#clipboard#Error()` report whether a
provider *executable was found*, not whether it can connect. Measured on this
machine: both reported healthy while `wl-copy` was failing to reach a Wayland
socket that does not exist.

### `"%` is empty

The buffer has no file name — a scratch buffer, or `:enew`. Expected.

## Check yourself

1. You `yy`, then `dd`, then `p`. Explain the result in terms of registers, and
   give the keystrokes that paste what you yanked.
2. Which register survives an arbitrary number of deletes, and which kind of
   operation writes to it?
3. You deleted three lines one after another. Where is the first of them now?
4. You `x` a character ten times. What is in `"1`?
5. How do you collect six scattered lines into one register and paste them
   together?
6. Give two ways to delete a line without losing what you are carrying.
7. Your paste keeps landing on a new line. Which column of `:registers` explains
   it, and why will pressing `P` instead not help?
8. `has('clipboard_working')` returns 1. What exactly have you learned, and what
   have you not?
9. Why is reading `getreg('+')` a bad test of whether a copy reached the OS?

<details><summary>Answers</summary>

1. `yy` wrote the line to the unnamed register and to `"0`; `dd` overwrote the
   unnamed register with the deleted line; `p` reads the unnamed register. Paste
   the yank with `"0p`.
2. `"0`. Only a yank writes to it — deletes never do.
3. `"3`. Each linewise delete pushes the queue down, so the oldest of three is in
   `"3` and the newest in `"1`.
4. Whatever the last *linewise* delete put there — `x` deletes less than a line, so
   all ten went to `"-`, each overwriting the last, and `"1` was never touched.
5. Yank the first with `"ayy`, then append each of the others with `"Ayy` (capital),
   and paste the collection with `"ap`.
6. `"_dd`, which sends it to the black hole; or name the register you are carrying
   in the first place, e.g. `"ayy` … `"ap`, so nothing can clobber it.
7. The `Type` column — `l` means linewise, and a linewise register always pastes
   as whole lines. `P` only changes the side (above instead of below), not whether
   it is line-oriented.
8. That Neovim found a provider executable on `PATH`. Not that the provider can
   connect, and not that any text has ever reached the system clipboard.
9. Neovim keeps its own copy of what you wrote to `"+`, so the read succeeds even
   when the provider failed. The only honest test leaves Neovim.

</details>

## Key takeaways

- The unnamed register takes yanks *and* deletes, which is the whole reason pastes
  seem to lose things. `"0` takes only yanks, so `"0p` is the recovery.
- `"_d` is the prevention, and naming a register is the habit — when you yank
  something for *later* rather than *next*, give it a name.
- `"1`–`"9` are a shifting history of linewise deletes; anything smaller than a
  line goes to `"-` instead, which is why the numbered queue sometimes looks stale.
- A register's *type* — charwise, linewise, blockwise — decides what `p` does. It
  is set when the text is captured, and it is the first column of `:registers`.
- Neovim has no clipboard code; it shells out to a provider found on `PATH`. So
  clipboard problems are provider problems.
- `has('clipboard_working')` means "a provider was found", and reading `"+` back
  always looks healthy. Verified on this machine while nothing reached the OS. The
  only real test is pasting into another application.

## Lookup (not the lesson)

| Tag | For |
|---|---|
| `:h registers` | the whole list, with which operation writes to which |
| `:h quotequote` | the unnamed register |
| `:h quote0` | the yank register, and `:h quote_number` for `"1`–`"9` |
| `:h quote-` | the small delete register |
| `:h quote_` | the black hole |
| `:h quote.` | and `:h quote:`, `:h quote%` — the read-only ones |
| `:h quote=` | the expression register, and `:h i_CTRL-R` for using it |
| `:h :registers` | the listing, including the Type column |
| `:h getregtype()` | and `:h getreg()`, `:h setreg()` — from Lua |
| `:h 'clipboard'` | `unnamed` and `unnamedplus` |
| `:h clipboard-tool` | the provider list, in priority order |
| `:h clipboard-wsl` | the WSL-specific advice |
| `:h gp` | and `:h ]p` — paste variants that adjust cursor and indent |

Now go to [`TASK.md`](TASK.md).
