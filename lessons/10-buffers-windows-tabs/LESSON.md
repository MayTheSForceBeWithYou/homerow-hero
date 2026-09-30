# 10 — Buffers, windows, tabs, and the argument list

People arriving from other editors map these onto tabs-in-a-tab-bar and get stuck,
because Neovim's model is genuinely different: a **buffer** is loaded text, a
**window** is a viewport onto one, and a **tab page** is a layout of windows. They
are three independent things with three independent counts, and the argument list is
a fourth collection that nobody mentions and `:argdo` makes useful.

## What this lesson asks of you

Say, from a `:ls` listing, which buffers are loaded, which are visible, and which
have unsaved changes — and move between them without closing anything.

This lesson changes `~/.config/hero`. The reference snapshot is `config/10`.

## Three things, three counts

- A **buffer** is a file's contents in memory. It exists whether or not you can see
  it.
- A **window** is a rectangle showing a buffer. Two windows can show the same buffer.
- A **tab page** is a collection of windows — a *layout*, not a file.

Measured. Three buffers open, then a horizontal and a vertical split, then a new tab:

```
buffers=3  windows=3  tabpages=1
after :tabnew   windows(total)=4  tabpages=2  windows(this tab)=1
```

Nothing forces those numbers to agree. And the same buffer really can appear twice:

```
:split
win1004->buf2   win1002->buf2   same=true
```

**The wrong reading to reject.** The instinct from other editors is that a tab page
is "an open file", so closing a tab should close the file. It is not: a tab page is a
window layout, and closing it leaves every buffer it showed loaded and intact. The
practical consequence is that Neovim users mostly do *not* use tab pages for files —
they switch buffers in one window, and reach for tab pages only when they want a
genuinely different *layout* (a three-window diff arrangement, say). If you find
yourself opening a tab per file, you are fighting the model.

## Reading `:ls`, column by column

This is the listing you will read hundreds of times, and the middle is where the
information is.

```
  1 #h   "alpha.txt"                    line 1
  2 %a   "beta.txt"                     line 1
  3      "gamma.txt"                    line 0
```

Five fields:

| Field | Here | Means |
|---|---|---|
| number | `1`, `2`, `3` | the buffer number — permanent for the session |
| flags | `#h`, `%a`, blank | see below |
| name | `"alpha.txt"` | in quotes; `[No Name]` when there is none |
| `line N` | `line 1`, `line 0` | the cursor line. **`line 0` means never loaded.** |

The flag block is **positional**: each column holds one of a mutually exclusive set,
so `#h` is two different facts and not a two-letter code. From `:h :ls`:

| Column | Characters | Meaning |
|---|---|---|
| 1 | `u` | unlisted (only shown with `:ls!`) |
| 2 | `%` / `#` | in the current window / is the alternate buffer |
| 3 | `a` / `h` | active: loaded **and** visible / hidden: loaded, not displayed |
| 4 | `-` `=` `R` `F` `?` | unmodifiable / readonly / terminal states |
| 5 | `+` / `x` | **modified** / had read errors |

So read the example as: buffer 1 is the alternate buffer and is loaded but not
visible; buffer 2 is in the current window and visible; buffer 3 is listed but has
never been loaded, which its `line 0` confirms.

The recognition rule: **`+` in the last column is unsaved work.** `:ls` is how you
find what you forgot to write, and `a` versus `h` is the loaded-versus-visible
distinction that the buffer/window split creates in the first place.

`:ls!` adds unlisted buffers — help buffers, plugin scratch buffers. In the
measurement above the two listings were identical, because nothing unlisted existed
yet.

## Moving between buffers

| Command | Does |
|---|---|
| `:ls` | list them |
| `:b {N}` | go to buffer N |
| `:b {substring}` | go to the buffer whose name contains it — must be unique |
| `:bn` / `:bp` | next / previous |
| `:bd` | delete (unload) the buffer, closing no windows |
| `<C-^>` | toggle to the **alternate** buffer |

Measured:

```
:buffer alph   ->  alpha.txt      a substring is enough
:buffer 2      ->  beta.txt       or the number
<C-^>          ->  alpha.txt      toggle
<C-^>          ->  beta.txt       and back
```

`:b {substring}` is the one to build a habit around — you never need to look up a
number. And `<C-^>` is the cheapest navigation in the editor: it flips between the
two files you are actually working on, which is most of what buffer switching is for.
The `#` in a `:ls` listing tells you where it will take you.

## `'hidden'`: may you leave a modified buffer?

With `'hidden'` off — the default — Neovim refuses to abandon unsaved changes:

```
hidden off:  E37: No write since last change (add ! to override)
hidden on :  succeeded silently
             alpha still loaded and modified? true
```

With it on, the buffer becomes *hidden*: still loaded, still modified, just not
displayed. That is what the `h` flag means.

Almost every modern config sets `hidden`, because refusing to switch files is
obstructive once you trust yourself to save. The cost is real though: you can
accumulate unsaved buffers and not notice. `:ls` with its `+` column is the antidote,
and `:wa` writes them all.

## Windows

Splits, and the `<C-w>` prefix that drives them:

| Command | Does |
|---|---|
| `:sp` / `<C-w>s` | split horizontally |
| `:vs` / `<C-w>v` | split vertically |
| `<C-w>h j k l` | move to the window left/down/up/right |
| `<C-w>w` | cycle to the next window |
| `<C-w>c` / `:clo` | close this window (the buffer stays loaded) |
| `<C-w>o` / `:on` | close every *other* window |
| `<C-w>=` | equalise sizes |
| `<C-w>H J K L` | move this window to the far left/bottom/top/right |

Closing a window never unloads a buffer. That separation is the whole point: `<C-w>c`
is free, and the text is still there in `:ls`.

### Window ID versus window number

Two ways to refer to a window, and they behave differently:

```
winnr()=1   win_getid()=1002   total wins=3
after <C-w>j:  winnr()=2   but the other window keeps id 1002 (still valid: true)
```

From `:h window-number` and `:h window-ID`: the **number** comes from the window's
*arrangement* in the tab page and changes whenever windows open or close; the **ID**
is permanent for the session and valid across tabs.

You do not need this yet, but it is the distinction that makes `vim.api` window
functions make sense in lesson 22 — those take IDs, which is why a stored window
handle stays correct after the layout changes.

## Tab pages

`:tabnew`, `:tabclose`, `gt` / `gT` to cycle, `:tabs` to list. A tab page holds
windows, so `:tabnew` gives you a fresh layout with one window in it — as measured
above, total windows went to 4 while this tab had 1.

That is genuinely all you need. Tab pages are the least used of the three because
buffers already solve "I have many files open".

## The argument list

The fourth collection, and the one that makes bulk edits across files easy.

The **arglist** is the set of files you named on the command line — `nvim a.txt
b.txt` — and you can set it yourself with `:args`. It is *not* the buffer list.
Measured:

```
:args alpha.txt gamma.txt
:args  ->  [alpha.txt] gamma.txt
argc=2   buffers listed=4
```

Two files in the arglist while four buffers are loaded. The brackets mark the current
argument.

Why it matters: the `:*do` commands operate on **different collections**, and
choosing the right one is how you avoid editing files you did not mean to.

| Command | Runs on |
|---|---|
| `:argdo {cmd}` | every file in the argument list |
| `:bufdo {cmd}` | every listed buffer |
| `:windo {cmd}` | every window in this tab page |
| `:tabdo {cmd}` | every tab page |

Measured — `:argdo` with the arglist above, on a substitution plus `update`:

```
alpha.txt    first line = "ARG MODIFIED"
beta.txt     first line = "beta line 1"     <- untouched: not in the arglist
gamma.txt    first line = "ARG gamma line 1"
```

`beta.txt` was a loaded buffer and was not changed, because it was not an *argument*.
`:bufdo` would have changed it.

That is the reason to use `:argdo` for project-wide edits: you *declare* the file set
first, look at it with `:args`, and only then act. `:bufdo` acts on whatever you
happen to have opened, which is a much vaguer set.

`update` rather than `write` is deliberate — it writes only if the buffer was
modified, so a file the substitution did not touch keeps its timestamp.

## Worked example

You need to rename a function across four of the eleven files you have open.

```
:args lua/hero/*.lua           declare the set
:args                          look at it -- do this before acting
:argdo %s/old_name/new_name/ge | update
```

Three parts worth naming:

- **`:args` with a glob** builds the set. You can inspect it before doing anything,
  which you cannot meaningfully do with "every buffer I have open".
- **`e` flag** on the substitution, from lesson 08: files with no match must not stop
  the run. Without it, `:argdo` aborts at the first non-matching file.
- **`update`** writes only what changed.

**The wrong reading to reject.** The obvious alternative is `:bufdo %s/…/ge | update`,
and it usually appears to work. The problem is that "every listed buffer" includes
things you did not choose — a file you opened to read, a `:help` page you visited
(unlisted, so safe here, but plugin buffers often are listed), the buffer you
created with `:enew`. A project-wide substitution is exactly the operation where an
accidentally included file is expensive and silent. `:argdo` makes the file set an
explicit, inspectable decision; `:bufdo` makes it a side effect of your browsing
history.

## Distinctions worth keeping straight

| These look alike | but |
|---|---|
| buffer / window | loaded text / a viewport onto it — one buffer can be in two windows |
| window / tab page | a viewport / a *layout* of viewports |
| tab page / "open file" | a layout; closing it unloads nothing |
| `a` flag / `h` flag | loaded **and** visible / loaded, not displayed |
| `+` flag / `=` flag | modified / readonly |
| `:ls` / `:ls!` | listed buffers / plus unlisted ones |
| `:bd` / `:clo` | unload the buffer / close the window, buffer stays |
| `<C-w>c` / `<C-w>o` | close this window / close all the *others* |
| `winnr()` / `win_getid()` | position-based, changes / permanent for the session |
| buffer list / argument list | everything loaded / the set you declared |
| `:bufdo` / `:argdo` | whatever you happen to have open / the set you chose |
| `write` / `update` | always write / write only if modified |
| `'hidden'` on / off | you may leave a modified buffer / `E37` stops you |

## Common errors

### `E37: No write since last change (add ! to override)`

`'hidden'` is off and the buffer you are leaving has unsaved changes. Write it, set
`hidden`, or force with `!` — knowing that `!` discards the changes.

### `:bd` closed my window too

`:bd` unloads the buffer, and a window showing nothing has to show something else —
or close, if it was the last one. If you wanted to keep the layout, switch the window
to another buffer first, or use `:bd` from a different window.

### `:b foo` says `E93: More than one match`

The substring is not unique. Type more of it, or use the number from `:ls`.

### `:ls` shows a buffer at `line 0`

It has never been loaded — added with `:badd` or named as an argument but not yet
visited. Its contents are not in memory.

### Your `:argdo` stopped on the third file

A command failed there. Add `e` to a substitution, or `silent!` before the command.
`:argdo` does not have `:g`'s error tolerance from lesson 09.

### `:argdo` changed nothing, or changed the wrong files

Check `:args` first. An empty arglist means `:argdo` has nothing to do; a stale one
means it is working on the files you named an hour ago.

### You lost track of unsaved work

`:ls` and look at the last flag column for `+`. `:wa` writes every modified buffer.

## Check yourself

1. Give the three counts — buffers, windows, tab pages — after opening three files
   and making one vertical split.
2. In `:ls`, what is the difference between `a` and `h`, and what does `line 0` tell
   you?
3. Which flag column means "unsaved changes", and what is the command that writes
   them all?
4. Why is `#` in a `:ls` listing useful, and which keystroke uses it?
5. What does `'hidden'` change, and what is the cost of turning it on?
6. Difference between `<C-w>c` and `:bd`?
7. Why does `winnr()` change when you close a window, while `win_getid()` does not?
8. You need a substitution across six specific files. Which `:*do` command, and name
   two things you would add to make it safe.
9. Someone says "I open a tab per file". What is the model mismatch?

<details><summary>Answers</summary>

1. 3 buffers, 2 windows, 1 tab page. The counts are independent.
2. `a` is active — loaded *and* visible in a window. `h` is hidden — loaded but not
   displayed. `line 0` means the buffer has never been loaded at all.
3. The last column, `+`. `:wa` (`:wall`) writes every modified buffer.
4. `#` marks the alternate buffer, which is where `<C-^>` will take you — so the
   listing tells you in advance what that toggle does.
5. It lets you leave a modified buffer without writing it, turning it into a hidden
   buffer instead of raising `E37`. The cost is that unsaved buffers accumulate
   invisibly; `:ls` and its `+` column is how you find them.
6. `<C-w>c` closes the window and leaves the buffer loaded. `:bd` unloads the buffer,
   which may also close the window that was showing it.
7. The number reflects the window's arrangement in the tab page and is recomputed as
   windows open and close; the ID is permanent for the session and valid across tabs.
8. `:argdo`, after declaring the set with `:args` and inspecting it. Add the `e` flag
   to the substitution so a non-matching file does not abort the run, and use
   `update` instead of `write` so untouched files keep their timestamps.
9. A tab page is a window *layout*, not a file. Buffers already hold the open files,
   so a tab per file duplicates what the buffer list does and makes switching harder.

</details>

## Key takeaways

- Buffer, window and tab page are three independent things: loaded text, a viewport,
  and a layout of viewports. Their counts need not agree, and one buffer can be in
  two windows.
- `:ls`'s flag block is positional, one mutually exclusive set per column. `a` versus
  `h` is loaded-and-visible versus loaded-and-hidden, and `+` is unsaved work.
- `:b {substring}` and `<C-^>` are the two navigation habits worth building; neither
  needs a buffer number.
- `'hidden'` trades `E37` for buffers you can lose track of. `:ls` and `:wa` are the
  counterweight.
- Closing a window never unloads a buffer, which is what makes splits cheap.
- The argument list is a set you *declare*. Prefer `:argdo` over `:bufdo` for
  project-wide edits, because the file set becomes an inspectable decision rather
  than a consequence of what you happened to open.

## Lookup (not the lesson)

| Tag | For |
|---|---|
| `:h windows.txt` | the whole chapter, and `:h buffers` for the model |
| `:h :ls` | the flag columns, verbatim |
| `:h hidden-buffer` | and `:h unlisted-buffer` |
| `:h 'hidden'` | the option |
| `:h CTRL-^` | the alternate-buffer toggle, and `:h alternate-file` |
| `:h CTRL-W` | every window command |
| `:h window-ID` | and `:h window-number` — why they differ |
| `:h argument-list` | the arglist, and `:h :args` |
| `:h :argdo` | and `:h :bufdo`, `:h :windo`, `:h :tabdo` |
| `:h tabpage` | tab pages, and `:h :tabs` |
| `:h :wall` | writing every modified buffer |

Now go to [`TASK.md`](TASK.md).
