# 11 — Search, `:grep`, quickfix and location lists

`/` finds the next match. That is a motion, and lesson 01 already made it one. What
this lesson adds is the **quickfix list** — a structured list of file/line/column
positions that you navigate with two keystrokes and can run a command over. It is the
mechanism behind every "find in project", every compiler error jump, and every LSP
diagnostic list you will ever use, and it is built in.

## What this lesson asks of you

Search a whole project, step through the results without losing your place, and apply
one edit to every result in one command.

This lesson changes `~/.config/hero`. The reference snapshot is `config/11`.

## Search, with the parts people skip

`/pattern` forward, `?pattern` backward, `n` / `N` to repeat. From lesson 03: all four
are jumps, so `<C-o>` brings you back.

`*` searches for the word under the cursor. It is worth knowing exactly what it
builds — measured, with the cursor on `alpha`, the command line shows:

```
/\<alpha\>
```

So `*` wraps the word in word boundaries: it finds `alpha` and not `alphabet`. `g*`
is the variant without the boundaries. That distinction is the whole difference
between "find this identifier" and "find this substring".

### Search offsets

A search can leave the cursor somewhere other than the start of the match, by
appending `/` and an offset. These are genuinely useful and almost nobody knows them.

Measured on `alpha NEEDLE one`, starting at column 1:

| Command | Lands at | Meaning |
|---|---|---|
| `/NEEDLE<CR>` | `{1, 6}` | start of the match (the default) |
| `/NEEDLE/e<CR>` | `{1, 11}` | **e**nd of the match |
| `/NEEDLE/b+2<CR>` | `{1, 8}` | 2 characters past the **b**eginning |
| `/NEEDLE/+1<CR>` | `{2, 0}` | a bare number is a **line** offset |

Two details from those measurements. `b` and `s` are synonyms — type `/NEEDLE/b+2`
and the command line normalises it to `/NEEDLE/s+2`. And a bare `+1` is *linewise*,
so the search becomes a line-oriented motion, which matters if you use it with an
operator.

`/pattern/e` is the one to remember: combined with an operator it gives you
"change up to and including that word", which no plain motion does as cleanly.

## The quickfix list

A quickfix entry is a **position with a message**: buffer, line, column, text.
Several commands fill the list; the navigation is the same regardless of what filled
it.

### Filling it with `:vimgrep`

`:vimgrep /pattern/ {files}` searches with Vim's own regex engine and fills quickfix.
Measured over three files:

```
:vimgrep /NEEDLE/j **/*.txt      ->  4 entries

1: bufnr=1 lnum=1 col=7  text="alpha NEEDLE one"
2: bufnr=1 lnum=3 col=7  text="gamma NEEDLE three"
3: bufnr=2 lnum=2 col=9  text="epsilon NEEDLE five"
4: bufnr=3 lnum=1 col=6  text="zeta NEEDLE six"
```

The `j` flag matters: without it, `:vimgrep` **jumps to the first match** as soon as
it finishes. With `j` it fills the list and leaves you where you are. Use `j` when you
want to look at the list first, which is most of the time.

`**/*.txt` is a recursive glob. `%` searches only the current file.

### Reading `:clist`

```
 1 a.txt:1 col 7-13: alpha NEEDLE one
 2 a.txt:3 col 7-13: gamma NEEDLE three
 3 b.txt:2 col 9-15: epsilon NEEDLE five
 4 sub/c.txt:1 col 6-12: zeta NEEDLE six
```

Five fields: the **entry number** (what you pass to `:cc`), the **file**, the **line**
after the colon, the **column range**, and the **line's text**. The entry number is
the one to notice — `:cc 3` jumps straight to the third result without stepping
through the first two.

### Navigating it

| Command | Does |
|---|---|
| `:copen` / `:cclose` | show / hide the quickfix window |
| `:cnext` / `:cprev` | next / previous entry |
| `:cfirst` / `:clast` | first / last |
| `:cc {N}` | entry N |
| `:clist` | print the list |

Measured:

```
:cfirst -> a.txt:1     "(1 of 4): alpha NEEDLE one"
:cnext  -> a.txt:3     "(2 of 4): gamma NEEDLE three"
:cnext  -> b.txt:2     "(3 of 4): epsilon NEEDLE five"
:clast  -> c.txt:1     "(4 of 4): zeta NEEDLE six"
:cnext  -> E553: No more items
```

The `(N of M)` message is free progress reporting, and `E553` at the end is how you
know you are done rather than stuck. Because `:cnext` and `:cprev` are long to type
and used constantly, they are the first thing anyone maps — `config/11` does.

The quickfix window is an ordinary window showing an ordinary buffer, with
`buftype=quickfix` and `filetype=qf`:

```
buftype="quickfix"  filetype="qf"  lines=4
```

So `<CR>` on a line jumps to it, and every window command from lesson 10 works on it.
Knowing its `filetype` is how you would later add a mapping that applies only there.

### `:cdo` — the payoff

`:cdo {cmd}` runs a command on **every entry**, and `:cfdo` runs it once per **file**.
This is the project-wide-edit tool, and it is better than lesson 10's `:argdo`
because the file set comes from a *search* rather than from a glob.

Measured — a substitution over the 4-entry list above:

```
:cdo s/NEEDLE/FOUND/e | update

a.txt      { "alpha FOUND one", "beta two", "gamma FOUND three" }
b.txt      { "delta four", "epsilon FOUND five" }
sub/c.txt  { "zeta FOUND six" }
```

The pieces, all carried over from earlier lessons: `e` from lesson 08 so a
non-matching entry does not abort the run, and `update` from lesson 10 so untouched
files keep their timestamps.

Use `:cfdo` when the command should run once per file rather than once per match — a
whole-file `%s///g`, for instance, where running it per entry would do the same work
repeatedly.

## Location lists: the same thing, per window

A **location list** is a quickfix list that belongs to one window. Every quickfix
command has an `l` twin: `:lvimgrep`, `:lopen`, `:lnext`, `:ldo`.

There is exactly one quickfix list for the whole session. There is one location list
*per window*. Measured:

```
qf entries=4   loclist entries (this window)=2
```

Both lists exist at once and hold different things. That is the entire reason
location lists exist: you can keep a project-wide search in quickfix while a
window-local list of "matches in this file" sits beside it, and neither disturbs the
other.

One inherited behavior worth knowing, measured:

```
after :split, loclist of the NEW window = 2
```

A new window created by splitting **inherits** the location list of the window it came
from. It is a copy, not a share — changing one afterwards does not change the other.

**The wrong reading to reject.** The natural assumption is that the `l` commands are
just an alias, so it does not matter which you use. It matters in one specific,
annoying way: because there is only one quickfix list, a second `:vimgrep` *replaces*
the first, and any list you were part way through is gone. LSP-style tools that want
to show you diagnostics without destroying your search results therefore use the
location list. When you are writing your own commands later, the rule is: use quickfix
for the thing the user asked for, and a location list for anything incidental.

## `:grep` versus `:vimgrep`

`:vimgrep` uses Vim's regex engine, in-process. `:grep` shells out to an external
program named by `'grepprg'`, and parses its output using `'grepformat'`.

Measured on this machine:

```
grepprg    = "rg --vimgrep -uu "
grepformat = "%f:%l:%c:%m"
```

**That ripgrep default is conditional.** Neovim's own runtime sets it when ripgrep is
available — `:verbose set grepprg?` reports *"Last set from Lua"*, not a built-in
default. Without ripgrep on `PATH`, the documented default is
`grep -HIn $* /dev/null`. So the same `:grep` command is fast and gitignore-aware on
one machine and plain POSIX grep on another, which is worth knowing before you build a
habit on top of it.

Which to use: `:grep` is dramatically faster on a large tree, and `:vimgrep` accepts
Vim patterns — `\zs`, `\v` and everything from lesson 08. Reach for `:grep` by
default; reach for `:vimgrep` when the pattern needs Vim's engine.

`'grepformat'`'s `%f:%l:%c:%m` is the field map that turns text output into structured
entries: file, line, column, message. `errorformat` does the same job for `:make`, and
that is how compiler errors become a navigable list.

## Worked example

Rename a function across a project, checking as you go.

```
:grep -w old_name              find it; -w is ripgrep's whole-word flag
:copen                         look at every hit before touching anything
```

Read the list. If it contains a vendored directory or a test fixture you did not mean
to touch, fix the search rather than the edit.

```
:cdo s/\<old_name\>/new_name/ge | update
```

Then verify:

```
:grep -w old_name              should now report nothing
```

Four habits in that sequence, and each one came from an earlier lesson: `\<…\>` word
boundaries so `old_name_2` survives, the `e` flag so a stale entry does not abort the
run, `update` so untouched files keep their timestamps, and re-running the search as
the check.

**The wrong reading to reject.** The tempting shortcut is `:cdo s/old_name/new_name/g`
— no boundaries, no `e`, no verification. It works on the happy path and fails in two
quiet ways: without `\<\>` it renames `old_name_helper` too, and without `e` it stops
at the first entry whose line has already been changed by a previous entry on the same
line, leaving the rename half-applied with no error you will notice. The check at the
end is what catches both, and it costs one command you have already typed once.

## Distinctions worth keeping straight

| These look alike | but |
|---|---|
| `*` / `g*` | with word boundaries / without |
| `/pat` / `/pat/e` | cursor at the match start / at its end |
| `/pat/+1` / `/pat/b+1` | a **line** offset / a character offset from the beginning |
| `b` / `s` in an offset | synonyms; Neovim normalises `b` to `s` |
| `:vimgrep` / `:grep` | Vim's engine, in-process / external `'grepprg'` |
| `:vimgrep /p/ f` / `:vimgrep /p/j f` | jumps to the first match / fills the list only |
| quickfix / location list | one per session / one per window |
| `:cnext` / `:lnext` | the global list / this window's list |
| `:cdo` / `:cfdo` | once per entry / once per file |
| `:cdo` / `:argdo` | the file set comes from a search / from a glob you typed |
| `'grepformat'` / `'errorformat'` | parses `:grep` output / parses `:make` output |
| `E553` / a hang | you reached the end of the list / something else is wrong |

## Common errors

### `:vimgrep` jumped you away from what you were reading

Without the `j` flag it jumps to the first match. Use `:vimgrep /pat/j {files}`.

### `E553: No more items`

You are at the end of the quickfix list. Not a failure — `:cfirst` to wrap round to
the start.

### Your second search destroyed the list you were stepping through

There is only one quickfix list. Use a location list (`:lvimgrep`) for the search you
want to keep, or `:grepadd` to append to the existing list instead of replacing it.

### `:cdo` changed nothing

The list is empty, or its entries are stale — a previous `:cdo` already changed those
lines so the pattern no longer matches. Re-run the search and look at `:clist`.

### `:cdo` stopped part way through

An entry's command failed. Add the `e` flag to a substitution, or `silent!` before the
command.

### `:grep` behaves differently on another machine

`'grepprg'` is set to ripgrep only when ripgrep is installed; otherwise it is
`grep -HIn $* /dev/null`, which does not understand ripgrep's flags. Check with
`:set grepprg?` before blaming the pattern.

### `:grep foo` found nothing though `/foo` finds it in the buffer

`:grep` searches files **on disk**. Unsaved changes are not there. Write first, or use
`:vimgrep` over `%`.

### `:grep` with a Vim pattern like `\v(a|b)` found nothing

`:grep` passes the pattern to an external program that does not speak Vim regex. Use
that program's syntax, or switch to `:vimgrep`.

## Check yourself

1. What does `*` build, and how does `g*` differ?
2. Give the search that leaves the cursor at the *end* of the match, and one reason
   that is useful.
3. What does the `j` flag do on `:vimgrep`, and when do you want it?
4. In `:clist` output, what is the first number for?
5. How many quickfix lists exist? How many location lists?
6. You are half way through stepping a search and need to search for something else
   without losing your place. What do you do?
7. Difference between `:cdo` and `:cfdo`, and when does the distinction matter?
8. Why might `:grep` behave differently on your laptop and your server?
9. `:grep` finds nothing but `/pattern` finds it in the buffer. Why?
10. Name the two flags you would add to `:cdo s/old/new/` to make it safe, and what
    each prevents.

<details><summary>Answers</summary>

1. `*` searches for `\<word\>` — the word under the cursor wrapped in word
   boundaries, so it will not match a longer identifier containing it. `g*` omits the
   boundaries and matches substrings.
2. `/pattern/e`. Combined with an operator it gives "act up to and including this
   match", which no plain motion expresses as cleanly.
3. It fills the list *without* jumping to the first match. You want it whenever you
   intend to look at the list before acting — which is most of the time.
4. The entry number, which you can pass to `:cc` to jump straight to that result.
5. One quickfix list for the whole session; one location list per window.
6. Use a location list for one of them — `:lvimgrep` — since it is per window and does
   not touch the quickfix list. Or `:grepadd` to append rather than replace.
7. `:cdo` runs the command once per *entry*; `:cfdo` once per *file*. It matters when
   the command is whole-file — a `%s///g` run per entry repeats the same work, and for
   a file with twenty matches that is twenty passes.
8. `'grepprg'` defaults to ripgrep only when ripgrep is installed; otherwise it is
   `grep -HIn $* /dev/null`, which does not accept ripgrep's flags.
9. `:grep` reads files on disk, so unsaved buffer changes are invisible to it. Write
   first, or use `:vimgrep`.
10. `\<` and `\>` around the pattern so a longer identifier containing it is not
    renamed, and the `e` flag so an entry whose line no longer matches does not abort
    the run part way through.

</details>

## Key takeaways

- The quickfix list is a structured list of positions with messages, and it is the
  mechanism behind every find-in-project and error-jump feature you will meet. The
  navigation is identical whatever filled it.
- `:vimgrep /pat/j` fills the list without jumping. The `j` is almost always what you
  want.
- There is **one** quickfix list and **one location list per window**. That is why
  incidental lists belong in a location list — a second `:vimgrep` destroys whatever
  you were stepping through.
- `:cdo` is the project-wide edit whose file set comes from a search rather than a
  glob. Combine it with lesson 08's `e` flag and lesson 10's `update`.
- `:grep` shells out to `'grepprg'`, which Neovim points at ripgrep **only when
  ripgrep is installed**. The same command is not the same command on two machines.
- `/pattern/e` and `*` versus `g*` are the two search details worth adding to your
  fingers.

## Lookup (not the lesson)

| Tag | For |
|---|---|
| `:h quickfix` | the whole chapter, and `:h quickfix.txt` |
| `:h :vimgrep` | Vim's own engine, and `:h :grep` for the external one |
| `:h 'grepprg'` | and `:h 'grepformat'` — note the quotes |
| `:h :copen` | the window, and `:h quickfix-window` for its buffer |
| `:h :cnext` | and `:h :cfirst`, `:h :clist`, `:h :cc` |
| `:h :cdo` | and `:h :cfdo` |
| `:h location-list` | why the `l` twins exist |
| `:h :lvimgrep` | and `:h :lopen`, `:h :lnext` |
| `:h search-offset` | every offset form |
| `:h star` | what `*` actually builds |
| `:h E553` | the end-of-list error |
| `:h getqflist()` | reading the list from Lua, and `:h setqflist()` for writing it |
| `:h errorformat` | how `:make` output becomes entries |

Now go to [`TASK.md`](TASK.md).
