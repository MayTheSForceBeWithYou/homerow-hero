# 09 — `:global` and `:normal`

Lesson 08 addressed lines by number or position. `:global` addresses them by
**content**: run a command on every line matching a pattern. Combine it with
`:normal`, which runs Normal-mode keystrokes from the command line, and you can
apply any edit you know how to type — including a macro from lesson 07 — to exactly
the lines that need it, in one command.

## What this lesson asks of you

Given "do this edit to every line that looks like *that*", write it as one command
and be able to say why it will not stop half way.

No config work. Nothing is added to `~/.config/hero`.

## `:global`

```text
:[range]g/{pattern}/{command}
```

Read it as: *for every line in range matching pattern, run command*. With
`:v` (or `:g!`) for the inverse — every line **not** matching.

The first thing to know is an exception to lesson 08:

**`:g` defaults to the whole file, not the current line.**

`:h :global` states it: *"The default for [range] is the whole buffer (1,$)."*
Measured, with the cursor on line 5 of a five-line buffer:

```
:g/DROP/d      ->  keep 1 | keep 2 | keep 3          every line considered
:s/keep/K/     ->  keep 1 | DROP a | keep 2 | DROP b | K 3    current line only
```

Same cursor, same buffer, and the two commands disagree about scope because their
defaults differ. This is worth holding on to: `:s` needs `%` to mean the file,
`:g` needs a range to mean anything *narrower* than the file.

```
:1,3g/keep/d   ->  DROP a | DROP b | keep 3       restricted to lines 1-3
```

### The command can be almost any Ex command

`:g` supplies the lines; you supply what to do with them.

```
:g/DROP/d                 delete matching lines
:v/keep/d                 delete non-matching lines -- "keep only the matches"
:g/keep/s/keep/K/         substitute, but only on matching lines
:g/DROP/s/$/;/            append to the end of matching lines
:g/DROP/m$                move matching lines to the end
:g/keep/t$                copy matching lines to the end
:g/^/m0                   reverse the file
```

All measured:

```
:v/keep/d      ->  keep 1 | keep 2 | keep 3
:g/DROP/s/$/;/ ->  keep 1 | DROP a; | keep 2 | DROP b; | keep 3
:g/DROP/m$     ->  keep 1 | keep 2 | keep 3 | DROP a | DROP b
:g/keep/t$     ->  keep a | x | keep b | keep a | keep b
:g/^/m0        ->  4 | 3 | 2 | 1
```

`:g/^/m0` deserves a moment: `^` matches every line, and `m0` moves each one to the
top, so each line in turn is moved above all the ones moved before it. That reverses
the file. It is the kind of thing that looks like a trick until you see the
mechanism, at which point it is obvious.

With no command at all, the default is `:p` — print. `:g/aa` lists the matching
lines, which is a quick way to see what your pattern would hit before you act on it.

### Deleting without clobbering your registers

From `:h :global`, verbatim: *"Using the underscore after `:d` avoids clobbering
registers or the clipboard. This also makes it faster."*

That underscore is lesson 05's black hole register. Measured — the unnamed register
before and after:

```
unnamed = "PRECIOUS"
:g/DROP/d     ->  unnamed = "DROP b\n"     clobbered
:g/DROP/d _   ->  unnamed = "PRECIOUS"     intact
```

So `:g/pattern/d _` is the form to prefer. If you are about to paste something you
yanked earlier, the difference is not academic.

### How it works, and why deleting lines does not skip any

Deleting lines while walking through them ought to be a bug — remove line 2 and what
was line 3 becomes line 2, so a naive loop skips it. `:g` does not have this
problem, and the reason is worth knowing.

`:h :global`, verbatim:

> The global commands work by first scanning through the `[range]` lines and marking
> each line where a match occurs […] In a second scan the `[cmd]` is executed for
> each marked line, as if the cursor was in that line. […] If a line is deleted its
> mark disappears.

**Two passes.** The pattern is matched against every line *before* anything is
executed, so the set of target lines is fixed in advance and renumbering cannot
disturb it. Measured on five consecutive matching lines:

```
:g/x/d _   on  x1 x2 x3 x4 x5   ->  (empty buffer)
```

All five, not every other one.

## `:normal`

```text
:[range]normal {keys}
```

Runs `{keys}` as though you typed them in Normal mode, once per line in the range.
This is the bridge between everything in lessons 01–07 and the addressing in lesson
08.

```
:normal A!       ->  a! | b        current line only (the usual default)
:%normal A!      ->  a! | b!       every line
```

Two details that bite:

**`:normal` obeys mappings; `:normal!` does not.** Measured with `X` mapped to
`ciwMAPPED<Esc>`:

```
:normal X    ->  MAPPED one | word two      the mapping ran
:normal! X   ->  word one   | word two      the built-in X ran
```

(The built-in `X` deletes the character *before* the cursor, and at column 1 there
is none — hence no visible change.) In a config or a script, always write
`:normal!`, so your code does not change behavior because the user mapped a key.

**The keystrokes must form a complete command.** `:h :global` warns: *"Make sure
that {commands} ends with a whole command, otherwise Vim will wait for you to type
the rest of the command for each match."* An `A!` is complete — `:normal` supplies
the implicit `<Esc>` at the end. A dangling `f` with no target character is not.

## The combination

```text
:g/{pattern}/normal {keys}
```

This is the payoff. It reads as: *on every line matching this, type these keys.*

And because a macro is just keystrokes in a register (lesson 07), `@q` is a valid
thing to type:

```
setreg q = 'I- <Esc>'
:g/todo/normal @q

"todo one"     ->  "- todo one"
"skip"         ->  "skip"
"todo two"     ->  "- todo two"
"skip"         ->  "skip"
"todo three"   ->  "- todo three"
```

The macro never has to move between lines. `:g` handles the selection *and* the
iteration, so the macro is only the per-line edit. That is usually a simpler macro
than the equivalent standalone one, because you can drop the trailing `j`.

### The contrast with a macro that matters

This is the reason both lessons exist, and the measured difference is stark. The
same failing operation — delete the character after a semicolon — over a buffer
where lines 2 and 4 have no semicolon:

```
99@q               with q = '0f;x'     ->  a1 | no2 | b;3 | no4 | c;5
:g/./normal 0f;x                       ->  a1 | no2 | b3  | no4 | c5
```

The macro **stopped** at line 2, exactly as lesson 07 described. `:g` **continued**.
That is documented, not incidental: *"If an error message is given for a line, the
command for that line is aborted and the global command continues with the next
marked or unmarked line."*

So the two tools have genuinely different failure behavior, and that is how you
choose between them:

- **A macro stops at the first surprise.** Use it when an unexpected line means you
  want to look before going further.
- **`:g` does not stop.** Use it when you have described the target lines precisely
  with a pattern and the non-matching ones are simply not your business.

Which also means the idiomatic `:g` version of the example does not rely on error
tolerance at all — it selects by pattern instead:

```
:g/;/normal 0f;x   ->  a1 | no2 | b3 | no4 | c5
```

Same result, and now it says what it means. **Prefer a precise pattern over
depending on errors being ignored**, because a pattern documents your intent and
error tolerance hides mistakes.

### Nesting `:g` with `:v`

One `:g` can drive another, which gives you "matches A but not B":

```
:g/found/v/notfound/normal A!

"found ok"        ->  "found ok!"
"found notfound"  ->  "found notfound"      excluded
"plain"           ->  "plain"               never matched
"found also"      ->  "found also!"
```

`:h :global` documents this and its restriction — `E147`: used recursively the inner
command works on one line only, and may not take a range.

## Worked example

A log file. You need to delete every `DEBUG` line, then add a `//` comment marker to
every line still mentioning `deprecated`, and you must not disturb the register you
have something yanked in.

```
:g/DEBUG/d _
:g/deprecated/normal I// 
```

Two commands, in that order, and the `_` on the first.

Build them the safe way rather than typing them straight in:

```
:g/DEBUG            list the lines the pattern hits -- default :p
```

Look at that output. If it includes something you did not expect, your pattern is
wrong and you have learned it before deleting anything. Then act.

**The wrong reading to reject.** The instinct, having learned macros in lesson 07,
is to solve this with `qq` … `q` and a big count — and it can be made to work.
But a macro has to do three jobs at once: find the next relevant line, decide whether
this line qualifies, and perform the edit. Encoding "decide whether this line
qualifies" into keystrokes means `/pattern<CR>` inside the macro, and now the macro's
behavior depends on search wrapping, on `'wrapscan'`, and on where the cursor
happened to start. `:g` separates the three concerns: the pattern decides *which*,
`:g` handles *iteration*, and `:normal` performs *the edit*. When a job is
"every line that looks like X", reach for `:g` first and keep macros for edits whose
repetition is positional rather than pattern-based.

## Distinctions worth keeping straight

| These look alike | but |
|---|---|
| `:s` default range / `:g` default range | the current line / the **whole file** |
| `:g` / `:v` | matching lines / non-matching lines (`:g!` is the same as `:v`) |
| `:g/pat/d` / `:g/pat/d _` | clobbers the unnamed register / uses the black hole |
| `:normal` / `:normal!` | obeys mappings / ignores them — always use `!` in a script |
| `:normal A!` / `:%normal A!` | the current line / every line |
| a macro's abort / `:g`'s error handling | stops everything / logs and continues |
| `:g/./normal …` / `:g/pattern/normal …` | relies on errors being ignored / says what it means |
| `:g/pat/m$` / `:g/pat/t$` | move matching lines / copy them |
| `:g` two-pass / a naive loop | marks first, then acts, so deleting skips nothing |
| `:g/aa` with no command / `:g/aa/d` | prints the matches / deletes them |

## Common errors

### `:g/pattern/d` deleted lines but also destroyed what you had yanked

`:d` writes to the unnamed register like any delete. Use `:g/pattern/d _`.

### `:g/…/normal f` hangs, or asks for input once per line

The keystrokes did not form a complete command — `f` is waiting for a character.
Give it one, or use a command that terminates.

### `:normal` behaved differently inside your config than when you typed it

`:normal` obeys mappings. A user (or an earlier line of your own config) mapped one
of the keys. Write `:normal!`.

### `:g/pattern/s/a/b/` changed nothing on lines you can see match

Check whether the *substitution's* pattern matches, not just `:g`'s. They are two
independent patterns, and it is easy to assume the second inherits the first. To
reuse `:g`'s pattern in the substitution, leave the substitution's pattern empty:
`:g/foo/s//bar/`.

### `E147: Cannot do :global recursive with a range`

You nested `:g` and gave the inner one a range. The inner command works on one line
only; drop the range.

### Your `:g` ran on the whole file when you wanted the visible part

`:g` defaults to the whole buffer. Give it a range: `:1,50g/…`, `:.,$g/…`, or select
lines and use `:'<,'>g/…`.

### The `:g` did something to a line that does not match

Almost always the *command* moved the cursor onto another line before doing its work.
`:g` puts the cursor on the marked line, and the command is free to leave it — a
`:normal` that ends with `j` will then operate one line further each time. Keep the
`:normal` part positional and let `:g` do the moving.

## Check yourself

1. What is `:g`'s default range, and how does that differ from `:s`?
2. Write a command that keeps only the lines containing `ERROR`.
3. What does the `_` do in `:g/x/d _`, and which lesson introduced it?
4. Why does `:g/x/d` not skip every other line when deleting consecutive matches?
5. A macro and a `:g/./normal` doing the same edit gave different results. Explain,
   and say which you would use for "every line that looks like X".
6. Why should a script always write `:normal!`?
7. `:g/^/m0` reverses the file. Explain the mechanism.
8. You want "lines containing `foo` but not `bar`". Write it.
9. `:g/foo/s//bar/` — what does the empty pattern do?

<details><summary>Answers</summary>

1. The whole buffer, `1,$`. `:s` defaults to the current line, so `:s` needs `%` to
   mean the file while `:g` needs a range to mean less than the file.
2. `:v/ERROR/d _` — or `:g!/ERROR/d _`.
3. It is the black hole register from lesson 05, so the deleted lines do not
   overwrite the unnamed register or the clipboard. The documentation notes it is
   also faster.
4. `:g` works in two passes: it marks every matching line first, then executes the
   command on each marked line. Renumbering during the second pass cannot change
   which lines were marked.
5. A macro aborts at the first error; `:g` logs the error for that line and
   continues with the next. For "every line that looks like X", use `:g` with a
   precise pattern — and prefer the precise pattern over relying on errors being
   ignored.
6. Because `:normal` obeys mappings, so the script's behavior would depend on the
   user's keymaps. `:normal!` runs the built-in commands.
7. `^` matches every line, and `m0` moves each matched line to the top. Each line in
   turn is placed above all the previously moved ones, which inverts the order.
8. `:g/foo/v/bar/{cmd}` — a nested `:v`. No range on the inner command (`E147`).
9. An empty pattern in the substitution reuses the last search pattern, which is the
   one `:g` just used. So the substitution acts on `foo` without repeating it.

</details>

## Key takeaways

- `:g/pattern/command` selects lines by content and runs a command on each.
  Its default range is the **whole file**, unlike every other Ex command you have
  met.
- It works in two passes — mark, then execute — which is why deleting matching lines
  never skips any.
- `:g/pattern/d _` uses the black hole so a bulk delete does not cost you your
  registers.
- `:normal` runs Normal-mode keys from the command line, and `:g/pat/normal @q`
  applies a macro to exactly the matching lines, with `:g` doing the iteration so the
  macro can be simpler.
- A macro aborts at the first error; `:g` continues past it. That difference is how
  you choose: a macro when a surprise should stop you, `:g` when the pattern has
  already said what counts.
- Prefer a precise pattern to relying on errors being ignored, and always write
  `:normal!` in a script.

## Lookup (not the lesson)

| Tag | For |
|---|---|
| `:h :global` | the command, the two-pass mechanism, and the range default |
| `:h :v` | and `:h :vglobal` — the inverse |
| `:h :normal` | running Normal-mode keys from an Ex command |
| `:h E147` | the restriction on nesting |
| `:h :move` | and `:h :copy`, `:h :t` — reordering commands worth using with `:g` |
| `:h :delete` | including the register argument |
| `:h quote_` | the black hole, from lesson 05 |
| `:h ex-cmd-index` | every Ex command, for when you want one `:g` can drive |

Now go to [`TASK.md`](TASK.md).
