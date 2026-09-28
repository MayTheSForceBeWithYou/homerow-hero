# 02 — Text objects

Lesson 01's grammar had a hidden cost: every motion is measured **from where the
cursor happens to be**, so `d$` from the middle of a line and `d$` from its start
do different things. Text objects remove the cursor's position from the question.
`ci(` changes what is inside the parentheses whether you are on the first
character, the last, or anywhere between — and it works across lines, which no
motion in lesson 01 could do.

## What this lesson asks of you

Stop aiming. Be able to name the text object for a construct — a word, a quoted
string, a function's argument list, an HTML element, a paragraph — and change it
without first navigating to its edge.

No config work. Nothing is added to `~/.config/hero`.

## The problem text objects solve

Here is the worked example from lesson 01, replacing a string's contents:

```
f"lct"goodbye<Esc>
```

Five keystrokes of navigation before the edit begins, and every one of them
depends on the cursor starting *before* the opening quote. Start one character
later and `f"` finds the closing quote instead, and the command destroys the line.

The text object version is `ci"`, from anywhere on the line. It does not care
where you are.

That is the whole idea: a motion describes **a distance**, an object describes
**a thing**. Objects are the reason experienced Vim users seem not to navigate.

## The grammar extends by one slot

```text
{operator} {count} {i|a} {object}
```

Text objects only work **after an operator** (or in Visual mode). There is no
"move by `iw`" — `iw` on its own in Normal mode is not a motion, and that is why
pressing `iw` without an operator drops you into Insert mode typing a `w`.

Every object comes in two sizes:

- **`i`** — *inner*. The content, without its delimiters.
- **`a`** — *a* / *around*. The content **with** its delimiters or surrounding
  whitespace.

Read `ci(` as "change inner parens" and `da"` as "delete a quoted string". The
mnemonic that sticks: `i` gives you what you would retype, `a` gives you what
would disappear from the page.

## Word objects, and the surprise inside `iw`

`iw` is a word, `aw` is a word plus one run of adjacent whitespace. On
`the quick brown fox` with the cursor **mid-word**, on the `o` of `brown`:

```
diw -> "the quick  fox"      the word only -- note the double space
daw -> "the quick fox"       the word and its trailing space
```

`iW` and `aW` are the same with WORDs — `W` means whitespace-delimited, so
punctuation does not split it. On `call obj.method(x)`, cursor on `method`:

```
diw -> "call obj.(x)"        iw stopped at the dots and the paren
diW -> "call "               iW took obj.method(x) entire
```

That contrast is the fastest way to remember the pair: lowercase respects
punctuation, uppercase ignores it.

### `iw` is not only "word"

Here is the part that surprises people, and the reason `3diw` produces an odd
result. `iw` means *inner word **or** whitespace run*. Put the cursor on the
space before `brown`:

```
diw -> "the quickbrown fox"     it deleted the space, not a word
daw -> "the quick fox"          it deleted the space and the word after it
```

So the buffer is a strip of alternating objects — word, gap, word, gap — and `iw`
selects whichever one you are standing on. This is exactly why counts behave the
way they do. On `one two three four` from column 1:

```
2daw -> "three four"        two words with their spaces
3diw -> " three four"       three objects: "one", " ", "two"
```

`3diw` did not delete three words. It deleted a word, a gap, and a word. If you
want *n* words, `aw` is the object that counts the way you expect.

**The wrong reading to reject.** People see `diw` leave a double space and
conclude `iw` is the "broken" one to be avoided. It is the precise one. Use `iw`
when something else will fill the space — `ciw` to retype a variable name, where
the spaces around it must survive. Use `aw` when the word should vanish and the
line should close up. Choosing between them *is* the skill; neither is a default.

### `daw` takes the space on whichever side exists

`aw` normally takes the trailing whitespace. At the end of a line there is none,
so it takes the leading whitespace instead. On `the quick brown fox` with the
cursor on `fox`:

```
daw -> "the quick brown"
```

Compare `dw` from the same position, from lesson 01, which left
`"the quick brown "` with a stray space. This is the fix for that footgun: `daw`
reaches behind the cursor, and no motion can.

## Block objects: parentheses, braces, brackets

| Object | Selects | Alias |
|---|---|---|
| `i(` `a(` | inside / around `( … )` | `ib` `ab` |
| `i{` `a{` | inside / around `{ … }` | `iB` `aB` |
| `i[` `a[` | inside / around `[ … ]` | — |
| `i<` `a<` | inside / around `< … >` | — |

`i)` and `i}` are the same as `i(` and `i{` — either delimiter of the pair names
the pair, so you never have to remember which one.

On `foo(bar, baz)` with the cursor on the `a` of `baz` — well inside, nowhere
near an edge:

```
di( -> "foo()"
da( -> "foo"
```

### They search forward when you are not inside one

This is documented and widely misremembered. `:h ib` says: *"If the cursor is not
inside a () block, then find the next `(`."* Measured, with the cursor at
column 1 — on the `f`, outside the parentheses entirely:

```
foo(bar)           di( -> "foo()"
aaaaaaaaaa(bar)    di( -> "aaaaaaaaaa()"
abc def (bar) ghi  di( -> "abc def () ghi"
```

So `ci(` works from the start of a line. The search does **not** go backwards,
though — with the cursor *after* the closing paren there is nothing ahead, and the
command does nothing:

```
foo(bar) tail      cursor at column 11 -> unchanged
```

And with no parenthesis on the line at all, nothing happens. A text object that
cannot find its target fails cleanly, exactly like a failed motion in lesson 01.

### Nesting is what counts are for

On `a(b(c)d)e` with the cursor on the `c`:

```
di(  -> "a(b()d)e"      the innermost block
2di( -> "a()e"          one level out
```

The count means "how many levels of nesting to climb", and this is the idiomatic
way to reach an enclosing block without navigating to it.

### The payoff is multi-line

Nothing in lesson 01 could do this. On

```
f = {
  a = 1,
  b = 2,
}
```

with the cursor anywhere on the first line:

```
di{ -> "f = {" / "}"        the body, gone; the braces kept
da{ -> "f = "               the whole block, gone
```

This is the move you will reach for constantly in a Neovim config, because a
plugin spec *is* a brace block.

## Quote objects

`i"` `a"`, `i'` `a'`, `` i` `` `` a` ``. Quotes also search forward on the line,
which is why `ci"` works from column 1:

```
say "hi there" now      ci"bye<Esc> -> "say \"bye\" now"
```

`a"` takes the quotes **and** the trailing whitespace:

```
say "hi there" now      da" -> "say now"
```

Quote objects are line-local: they never search onto the next line, and they have
no concept of nesting, so a count does nothing useful. They also do not understand
your language's escaping rules beyond the `'cpoptions'` `M` flag — see `:h cpo-M`.

## Tag objects

`it` and `at` work on a matched pair of markup tags. On `<p>hello</p>` with the
cursor on the `e`:

```
dit -> "<p></p>"      the contents
dat -> ""             the element, tags included
```

Counts climb nesting as with blocks. On `<a><b>x</b></a>` from the `x`:

```
dit  -> "<a><b></b></a>"
2dit -> "<a></a>"
```

These depend on the buffer's `filetype` being a markup type; in a plain-text
buffer they will not find anything.

## Paragraph and sentence objects

| Object | Selects |
|---|---|
| `ip` `ap` | inner / a paragraph — a run of non-blank lines |
| `is` `as` | inner / a sentence |

A paragraph is delimited by blank lines, and `ip` treats a *run of blank lines* as
an object of its own, exactly as `iw` does with whitespace. On
`a` / *(blank)* / *(blank)* / `b` with the cursor on the first blank line:

```
dip -> "a" / "b"        the blank run collapsed
```

On `p1a` / `p1b` / *(blank)* / `p2`:

```
dip -> "" / "p2"        the text lines; the blank survives
dap -> "p2"             the paragraph and its trailing blank
```

Sentences split on `.`, `!` or `?` followed by whitespace. On `One. Two. Three.`
with the cursor in `Two`:

```
das -> "One. Three."
dis -> "One.  Three."   note the double space -- `is` left both separators
```

## Worked example

A real edit from a Neovim config. The cursor is on the `n` of `nvim` in the first
line — inside the string, not near any bracket:

```lua
return {
  "nvim-treesitter/nvim-treesitter",
  opts = { ensure_installed = { "c", "lua" } },
}
```

**Goal one:** change the plugin name. It is a quoted string, so the object is
`i"`, and the cursor is already inside it: `ci"`. Done — no navigation, and it
would have worked from anywhere on that line.

**Goal two:** replace the whole `opts` value. Put the cursor anywhere on the
`opts` line. The value is a brace block, so `ci{`. But there are *two* nested
brace blocks on that line, and `i{` finds the innermost containing the cursor.
With the cursor on `opts`, you are inside neither — so the forward search finds
the first `{` and you get the outer one. With the cursor on the `"c"`, you are
inside the inner block and `ci{` targets that; `2ci{` climbs to the outer.

**The wrong reading to reject.** The instinct on seeing nesting is to navigate to
the bracket you want and *then* use the object — `f{ci{`. That reintroduces the
position-dependence the objects exist to remove, and it breaks the moment the
line is reformatted. The count is the tool for choosing a level: decide *how many
levels out*, not *which character to sit on*.

**Goal three:** delete the whole spec body, keeping `return { }`. The cursor can
be on any of the three lines, because the block spans them: `di{`.

That last one is the summary of the lesson. Three lines of structured text, one
object, no navigation, and no dependence on how the code is indented or wrapped.

## Distinctions worth keeping straight

| These look alike | but |
|---|---|
| `iw` / `aw` | `iw` is the word alone; `aw` adds one whitespace run |
| `iw` / `iW` | `iw` breaks at punctuation; `iW` breaks only at whitespace |
| `3diw` / `3daw` | `iw` counts words *and* gaps, so `3diw` is word-gap-word |
| `daw` / `dw` | `daw` can reach whitespace *behind* the cursor; `dw` never can |
| `di(` / `da(` | `i` keeps the parentheses, `a` removes them |
| `i(` / `ib` | identical; `ib` is just the mnemonic spelling |
| `i(` / `i)` | identical — either delimiter names the pair |
| `2di(` / `d2i(` | both climb one nesting level; the count may sit either side |
| `ci"` / `f"lct"` | same result; only `ci"` is independent of the cursor |
| text object / motion | objects need an operator; motions also move on their own |
| `ip` / `ap` | `ip` is the lines; `ap` adds the trailing blank line |

## Common errors

### You typed `iw` and ended up in Insert mode typing `w`

Text objects are not motions. In Normal mode `i` starts Insert. An object is only
valid after an operator (`diw`) or inside Visual mode (`viw`).

### `di(` did nothing and you were sure the cursor was in the right place

Three causes, in order of likelihood. The cursor was **after** the closing
parenthesis — the forward search only looks ahead. There is no parenthesis on the
line. Or the block is empty: `:h ib` states that selecting an empty inner block
like `()` is an error, and measured on `foo()`, `di(` leaves the line unchanged.
(`ci(` on the same empty block *does* work, since there is something to insert.)

### `ciw` left the surrounding spaces and you wanted them gone

That is `iw` doing its job. You wanted `caw`.

### `dit` did nothing in a file that is full of HTML

Check `:lua = vim.bo.filetype`. Tag objects need the buffer recognized as a markup
filetype; a buffer created without a name, or with the wrong extension, will not
have one.

### `3diw` deleted two words and a space instead of three words

`iw` alternates between words and whitespace runs, so a count of 3 spans
word-gap-word. Use `3daw` for three words.

## Check yourself

1. Buffer is `the quick brown fox`, cursor on the `o` of `brown`. Give the exact
   result of `diw` and of `daw`, spaces included.
2. Why does `ci"` work from column 1 of the line, when `ct"` needs the cursor
   before the opening quote?
3. On `a(b(c)d)e` with the cursor on `c`, what does `2di(` leave, and what does
   the count mean?
4. Cursor is on the space between two words. What does `diw` delete?
5. You want to delete three whole words. Which command, and why not `3diw`?
6. Name one thing `daw` can do that no lesson-01 motion can.
7. `di(` with the cursor after the closing paren does nothing. Why is that
   consistent with how these objects find their target?
8. What must be true of the buffer for `dit` to work?

<details><summary>Answers</summary>

1. `diw` leaves `"the quick  fox"` — two spaces, because only the word went.
   `daw` leaves `"the quick fox"` — the word and its trailing space.
2. `i"` searches forward on the line when the cursor is not already inside a
   quoted string, so it finds the pair regardless of position. `t"` is a motion:
   it measures from the cursor and searches forward for a `"`, which from before
   the string finds the *opening* quote.
3. `"a()e"`. The count is how many levels of nesting to climb outward, not how
   many characters or blocks to take.
4. The run of whitespace you are standing on. `iw` means inner word *or*
   whitespace run, whichever the cursor is in.
5. `3daw`. `iw` alternates word and gap, so `3diw` spans word-gap-word — two
   words and a space.
6. Reach whitespace *behind* the cursor. On the last word of a line `daw` removes
   the preceding space; `dw` leaves it, because an operator with a motion only
   affects text from the cursor forward.
7. The search only looks ahead. Past the closing parenthesis there is no `(` left
   on the line, so the object has no target and the operator aborts without
   changing anything — the same clean failure as a motion that cannot move.
8. Its `filetype` must be a markup type. Check with `:lua = vim.bo.filetype`.

</details>

## Key takeaways

- A motion describes a distance from the cursor; an object describes a thing. The
  object is why fluent editing looks like it skips the navigation.
- `i` is the content, `a` is the content plus its delimiters or one whitespace
  run. Choosing between them is the actual decision, and neither is a default.
- `iw` selects a word *or* a whitespace run, which is why counts on `iw` step
  through gaps as well as words.
- Block and quote objects search forward on the line when the cursor is not
  already inside one — so `ci(` and `ci"` work from column 1.
- Counts on block and tag objects climb nesting levels. Use the count rather than
  navigating to the bracket you want.
- Objects span lines. `di{` on a multi-line table is the move that makes editing
  a plugin spec quick, and lesson 01 had no equivalent.

## Lookup (not the lesson)

| Tag | For |
|---|---|
| `:h text-objects` | the whole chapter |
| `:h iw` | and `:h aw`, `:h iW` — the word objects |
| `:h ib` | the block objects, including the forward-search sentence |
| `:h i(` | the bracket spellings |
| `:h it` | and `:h at` — tag objects |
| `:h ip` | and `:h is` — paragraph and sentence |
| `:h cpo-M` | how escaped delimiters are treated |
| `:h [(` | the underlying "go to unmatched bracket" motion |
| `:h WORD` | the WORD versus word definition |

Now go to [`TASK.md`](TASK.md).
