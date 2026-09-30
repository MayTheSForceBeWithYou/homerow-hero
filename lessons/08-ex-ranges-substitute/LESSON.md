# 08 — Ex ranges and `:substitute`

Everything so far has edited text near the cursor. Ex commands edit text by
*address*: "lines 1 to 20", "from here to the end", "every line". `:%s/old/new/g`
is the one everybody knows, and it is four separate ideas glued together — a range,
a command, a pattern, and flags. Taking them apart is what lets you write the other
several hundred useful combinations.

## What this lesson asks of you

Address exactly the lines you mean, and write a substitution whose replacement
refers back to what it matched.

No config work. Nothing is added to `~/.config/hero`.

## The shape of an Ex command

```text
:[range]command[arguments]
```

The range is optional and defaults to **the current line** for most commands. That
default is the first thing to internalise, because it explains the difference
between the two commands people confuse:

```
:s/a/X/     acts on the current line only
:%s/a/X/    acts on every line
```

Measured on five lines each containing `a`, with the cursor on line 3:

```
:s/a/X/     ->  one a | two a | three X | four a | five a
:%s/a/X/    ->  one X | two X | three X | four X | five X
```

`%` is not a wildcard. It is an address meaning "the whole file", exactly equivalent
to `1,$`.

## Addresses

A range is one address, or two separated by a comma.

| Address | Means |
|---|---|
| `5` | line 5 |
| `.` | the current line |
| `$` | the last line |
| `%` | the whole file — shorthand for `1,$` |
| `'a` | the line holding mark `a` (lesson 03) |
| `'<,'>` | the last Visual selection |
| `/pattern/` | the next line matching the pattern |
| `?pattern?` | the previous line matching |
| `+N` / `-N` | N lines after / before the previous address |
| `\/` | the next line matching the **last** search |

Measured, all on the same five-line buffer:

```
:1,3s/a/X/     ->  one X | two X | three X | four a | five a
:.,+2s/a/X/    cursor on line 2  ->  one a | two X | three X | four X | five a
:$s/a/X/       ->  ... | five X
:.,$s/a/X/     cursor on line 4  ->  ... | four X | five X
:/three/s/a/X/ ->  one a | two a | three X | four a | five a
```

`.,+2` is the one worth memorising: **this line and the next two**. Combined with
`.,$` ("from here down") it covers most of what you actually want, and neither
requires you to look at line numbers.

### The Visual-mode range writes itself

Select lines in Visual mode, press `:`, and Neovim inserts `'<,'>` for you:

```
Vj  then  :         the command line already reads  :'<,'>
```

Measured — selecting lines 2 and 3, then substituting:

```
Vj<Esc>:'<,'>s/a/X/    ->  one a | two X | three X | four a | five a
```

Those are the marks from lesson 03, which is why the range survives after you leave
Visual mode. This is the most common way to apply a substitution to "these lines
here" without thinking about numbers at all.

## `:substitute`

```text
:[range]s/pattern/replacement/[flags]
```

The `/` is just a delimiter — any non-alphanumeric character works, which is the
standard way to avoid escaping slashes in paths:

```
:s#/usr/local#/opt#
```

### Flags worth knowing

| Flag | Does |
|---|---|
| `g` | every match on the line, not just the first |
| `c` | confirm each replacement interactively |
| `i` | ignore case for this substitution |
| `I` | force case sensitivity for this substitution |
| `e` | no error if the pattern is not found |
| `n` | count matches and change nothing |

Measured:

```
"a a a"  :s/a/X/     ->  X a a      without g, one match per line
"a a a"  :s/a/X/g    ->  X X X
"ABC"    :s/abc/X/i  ->  X
"ABC"    :s/abc/X/I  ->  ABC        no match, case forced
"a a a"  :s/a/X/gn   ->  a a a      counted only; nothing changed
"abc"    :s/zzz/X/   ->  abc        and reports E486: Pattern not found
"abc"    :s/zzz/X/e  ->  abc        silent
```

`g` is per-line, not per-file — `:%s/a/X/` without `g` replaces the *first* `a` on
every line. The two are independent: `%` chooses the lines, `g` chooses how many
matches within each.

`n` is genuinely useful as a counter: `:%s/pattern//gn` reports how many matches
exist without touching the buffer.

And `e` is the flag from lesson 07: it is what stops a failed substitution from
aborting a macro.

## The replacement side has its own language

This is the half people skip, and it is where the power is.

| In the replacement | Means |
|---|---|
| `&` or `\0` | the whole match |
| `\1` … `\9` | capture groups |
| `~` | the previous replacement string |
| `\u` / `\l` | upper/lowercase the **next character** |
| `\U` / `\L` | upper/lowercase **until** `\E` |
| `\=expr` | the result of evaluating a Vimscript expression |
| `\r` | a newline (not `\n`, which inserts a NUL) |

Measured:

```
"abc"         :s/b/[&]/                       ->  a[b]c
"abc"         :s/b/[\0]/                      ->  a[b]c
"john smith"  :s/\(\w\+\) \(\w\+\)/\2, \1/    ->  smith, john
"hello world" :s/\<\w/\u&/g                   ->  Hello World
"abc def"     :s/\w\+/\U&/                    ->  ABC def
"a b"         :s/a/ZZ/  then  :s/b/~/         ->  ZZ ZZ
"x"           :s/x/\=2+3/                     ->  5
```

`\u&` is the idiom for "capitalise": match a word's first character with `\<\w` and
uppercase it. Worth keeping.

`\=` evaluates an expression, which means a substitution can compute its
replacement. Lesson 21 returns to this once `vim.fn` is available, because
`\=` can call functions.

### `\zs` and `\ze` trim the match without capturing

These set where the match *starts* and *ends*, so the surrounding pattern acts as
context rather than as something to replace:

```
"foobar"   :s/foo\zsbar/X/   ->  fooX      matched only "bar", required "foo" before it
"foobar"   :s/foo\zebar/X/   ->  Xbar      matched only "foo", required "bar" after it
```

Without `\zs` you would need `:s/foo\(bar\)/foo\1…/` and a capture group to put the
context back. `\zs` is shorter and says what you mean: *this* is the bit to change.

### Very magic: `\v`

Vim's default pattern syntax requires backslashes before `(`, `)`, `+`, `|`, `{`.
`\v` at the start turns that off and gives you something close to PCRE:

```
:s/\(\w\+\) \(\w\+\)/\2, \1/       default syntax
:s/\v(\w+) (\w+)/\2, \1/           very magic -- same result
```

Both measured to produce `smith, john`. `\v` is worth using whenever a pattern has
more than one group; the backslashes stop being noise.

### Repeating a substitution

| Command | Repeats the last substitution |
|---|---|
| `&` | on the current line, **without** its flags |
| `:&&` | on the current line, **with** its flags |
| `:%&&` | on every line, with its flags |

Measured — substituting on line 2, moving to line 3, then `:&&`:

```
:2s/a/X/  then  :3  then  :&&   ->  one a | two X | three X | four a | five a
```

The distinction matters because `&` silently drops your `g`, which is why a
"repeat" sometimes changes only the first match.

## Worked example

You have a config file full of old-style option calls and you need to convert them:

```lua
vim.api.nvim_set_option('number', true)
vim.api.nvim_set_option('expandtab', true)
vim.api.nvim_set_option('shiftwidth', 2)
```

Target: `vim.opt.number = true`, and so on.

Build it in pieces rather than writing one long command.

**The range.** These are three consecutive lines and you are on the first, so
`.,+2` — or select them with `Vjj` and let `'<,'>` write itself. Prefer the Visual
version when you can see the lines; prefer `.,+2` when your hands are already on the
command line.

**The pattern.** Two things vary: the option name and the value. Both need
capturing, so `\v` is worth it:

```
\vvim\.api\.nvim_set_option\('(\w+)', (.+)\)
```

**The replacement.** Refer back with `\1` and `\2`:

```
vim.opt.\1 = \2
```

Together:

```
:.,+2s/\vvim\.api\.nvim_set_option\('(\w+)', (.+)\)/vim.opt.\1 = \2/
```

**Check before you commit.** Two habits make this safe:

```
:.,+2s/\v…//gn        count the matches first -- expect 3
:.,+2s/…/…/gc         or confirm each one interactively
```

**The wrong reading to reject.** The instinct is to write the whole command and
press Enter, then `u` if it goes wrong. Undo does work, and for a three-line range
it is fine. The habit fails on `:%s`, because a pattern that matches more broadly
than you intended can change hundreds of lines across the file, and `u` restores
them all — including the ones you *did* want. Then you cannot tell which is which.
Running the `n` flag first costs one keystroke and tells you the count; if the
number surprises you, your pattern is wrong and you have learned that for free.

## Distinctions worth keeping straight

| These look alike | but |
|---|---|
| `:s` / `:%s` | current line / every line — the range defaults to `.` |
| `%` as a range / `%` as a filename | whole file / the current file's name (lesson 05's `"%`) |
| `g` flag / `%` range | all matches **on a line** / all lines — independent |
| `.,+2` / `.,2` | this line and the next two / from here **to** line 2 |
| `'<,'>` / `1,$` | the last Visual selection / the whole file |
| `&` / `:&&` | repeat without the flags / repeat with them |
| `/pat/` as an address / as a search | the next matching **line** / a motion |
| `\zs` / a capture group | trims the match / keeps it and puts it back |
| `\v` / default syntax | `(` groups / `\(` groups |
| `\r` / `\n` in a replacement | a newline / a NUL byte |
| `&` in a replacement / `&` as a command | the whole match / repeat the substitution |
| `/e` flag / `/g` flag | do not error on no match / replace every match |

## Common errors

### `E486: Pattern not found: foo`

The pattern did not match in the range. Check the range first — `:s` only looked at
the current line. Add `e` if the absence is expected, as inside a macro.

### `:%s/a/X/` changed only one `a` per line

That is `g`'s job, and you did not pass it. `%` chose the lines; `g` chooses the
matches within each line.

### Your pattern with `(` groups matched nothing

Default syntax needs `\(` and `\)`. Either escape them, or put `\v` at the start of
the pattern and use bare parentheses.

### `\n` in the replacement inserted a strange character

In a *replacement*, `\n` is a NUL byte. Use `\r` for a newline. (In a *pattern*,
`\n` does mean newline — the asymmetry is real and catches everyone once.)

### `&` repeated the substitution but changed only the first match

`&` drops the flags. Use `:&&` to keep them.

### The substitution hit far more lines than intended and undo made it worse

`u` reverts the whole substitution, including the parts you wanted. Count first with
the `n` flag, or use `c` to confirm interactively.

### `:'<,'>s/…` says `E20: Mark not set`

There has been no Visual selection in this buffer yet, so `'<` and `'>` do not
exist. Select something first.

## Check yourself

1. What range does `:s/a/b/` use, and what does `:%s/a/b/` use?
2. Give the range for "this line and the next three" and for "this line to the end
   of the file".
3. `:%s/x/y/` changed one `x` per line. Why, and what fixes it?
4. Write a substitution that swaps two space-separated words on the current line,
   using very magic syntax.
5. What does `\zs` do, and what would you have to write instead without it?
6. You want to know how many times a pattern occurs in the file without changing
   anything. Which command?
7. Difference between `&` and `:&&`?
8. You want a newline in a replacement. Which escape, and what does the other one
   do?
9. How does `'<,'>` end up on the command line, and which lesson-03 feature makes it
   work?

<details><summary>Answers</summary>

1. `:s` uses the current line (the default range for most commands). `%` means the
   whole file, equivalent to `1,$`.
2. `.,+3` and `.,$`.
3. The `g` flag was missing. `%` selects the lines; `g` selects all matches within
   each line. `:%s/x/y/g`.
4. `:s/\v(\w+) (\w+)/\2 \1/`
5. `\zs` sets where the match starts, so the text before it is required context but
   is not replaced. Without it you would capture the context in a group and put it
   back in the replacement: `:s/\(foo\)bar/\1X/`.
6. `:%s/pattern//gn` — the `n` flag counts and changes nothing.
7. `&` repeats the last substitution without its flags; `:&&` repeats it with them.
8. `\r` inserts a newline. `\n` in a replacement inserts a NUL byte.
9. Pressing `:` in Visual mode inserts it automatically. It works because the
   selection is stored in the `'<` and `'>` marks, which persist after Visual mode
   ends.

</details>

## Key takeaways

- An Ex command is `:[range]command[args]`, and the range defaults to the current
  line. That default is the whole difference between `:s` and `:%s`.
- `.,+N` and `.,$` address relative to where you are, so you never read line
  numbers. `'<,'>` writes itself from Visual mode.
- `%` picks lines and `g` picks matches within a line. They are independent, and
  confusing them is the most common substitution mistake.
- The replacement side is a small language: `&` for the whole match, `\1` for
  groups, `\u` and `\U` for case, `\=` to compute. `\r` is a newline; `\n` is not.
- `\zs` and `\ze` express "match this, given that context" without capture groups.
- `\v` removes the backslashes from grouping and alternation, and is worth using as
  soon as a pattern has more than one group.
- Count with the `n` flag before running a wide substitution. Undo cannot tell your
  intended changes from the accidental ones.

## Lookup (not the lesson)

| Tag | For |
|---|---|
| `:h :range` | every address form, and `:h cmdline-ranges` |
| `:h :substitute` | the command, and `:h :s` for the short form |
| `:h :s_flags` | `g` `c` `i` `I` `e` `n` and the rest |
| `:h sub-replace-special` | `&`, `\1`, `\u`, `\U`, `\r` |
| `:h sub-replace-expression` | the `\=` form |
| `:h /\zs` | and `:h /\ze` |
| `:h /\v` | very magic, and `:h /magic` for all four levels |
| `:h :&&` | repeating with flags, and `:h &` without |
| `:h last-pattern` | why an empty pattern reuses the last search |
| `:h 'gdefault'` | the option that inverts `g` — mentioned so you recognise it in someone else's config |
| `:h v_:` | why `:` in Visual mode prefills a range |

Now go to [`TASK.md`](TASK.md).
