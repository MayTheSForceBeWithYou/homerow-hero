# 12 — `:help` as a database

Every lesson so far has ended with a **Lookup** table, on the principle that the
lesson teaches what to look for and `:help` supplies the spelling. This lesson is
about the supplying. Neovim's help is not prose to read through — it is 10,802 tagged
entries across 135 files, and the skill is querying it. Done properly you stop needing
a cheatsheet, because the answer is three keystrokes away.

## What this lesson asks of you

Find the documentation for something you only half remember, in one command, without
guessing.

No config work. Nothing is added to `~/.config/hero`.

## The tag namespace, and why the same word is several tags

This is the single most important thing in the lesson, and it is the reason people
conclude the help is bad.

**Punctuation is part of the tag.** `list` is not one entry; it is at least three.
Measured — the same word, four spellings, four destinations:

```
:h list       -> vimeval.txt:216     the List data type
:h 'list'     -> options.txt:4108    the option
:h :list      -> various.txt:132     the Ex command
:h v_list     -> FAILED              no such tag
```

So "I looked up `list` and got the wrong thing" is not the help failing. It is a query
for a different entry than the one you wanted.

The same applies to control keys, which appear once per mode:

```
:h CTRL-W     -> index.txt:514       the window prefix, in Normal mode
:h i_CTRL-W   -> insert.txt:64       delete-word-back, in Insert mode
:h c_CTRL-W   -> cmdline.txt:122     delete-word-back, on the command line
```

Three pages, three behaviors, one keystroke. Lesson 06 met exactly this with
`<C-w>`, and now you can look up either one deliberately.

### The conventions, in one table

All measured:

| Spelling | Means | Example resolves to |
|---|---|---|
| `'name'` | an **option** — quoted | `:h 'number'` → options.txt |
| `:name` | an **Ex command** — leading colon | `:h :number` → various.txt |
| `name()` | a **function** — trailing parens | `:h expand()` → vimfn.txt |
| `vim.mod.fn()` | a **Lua** function | `:h vim.keymap.set()` → lua.txt |
| `i_` `c_` `v_` `g_` prefix | that key **in that mode** | `:h i_CTRL-O` → insert.txt |
| `/item` | a **pattern** item | `:h /\zs` → pattern.txt |
| `ENNN` | an **error number** | `:h E37` → message.txt |
| `name.txt` | a whole **help file** | `:h quickfix.txt` → its first line |

Two habits follow. When you want an option, type the quotes — every Lookup table in
this course does, which is why. And when a lookup gives you something unrelated, do
not conclude the topic is undocumented: add the punctuation that narrows it.

An unknown tag says so plainly:

```
:h no_such_tag_at_all   ->   E149: No help for no_such_tag_at_all
```

## Completion is the discovery mechanism

You cannot type a tag you do not know. You can type a *prefix* and press `<Tab>` —
and this is the part that replaces a cheatsheet.

Measured counts of completion candidates:

```
:h vim.keymap<Tab>     ->  3 matches:  vim.keymap  vim.keymap.del()  vim.keymap.set()
:h nvim_buf_set<Tab>   ->  9 matches:  nvim_buf_set_var()  nvim_buf_set_mark()  nvim_buf_set_name()
                                       nvim_buf_set_text()  nvim_buf_set_lines()  …
:h i_CTRL-<Tab>        -> 69 matches:  i_CTRL-@  i_CTRL-[  i_CTRL-]  i_CTRL-^  …
:h 'shift<Tab>         ->  2 matches:  'shiftround'  'shiftwidth'
```

`:h i_CTRL-<Tab>` is worth doing right now: it is the complete list of Insert-mode
control keys, which is exactly what lesson 06 covered a selection of.

Press `<C-d>` instead of `<Tab>` to *list* the matches without inserting one.

### Wildcards, which almost nobody knows

The completion accepts `*`:

```
:h *quickfix*<Tab>   -> 32 matches:  quickfix  quickfix-ID  quickfix-gcc  quickfix.txt  …
:h vim.*.set<Tab>    -> 20 matches:  vim.keymap.set()  vim.diagnostic.set()
                                     vim.lsp.set_log_level()  vim.lsp.util.set_lines()  …
```

This is the answer to "there is a function that sets *something*, somewhere in the
`vim.` namespace". You do not need to know the module. `:h vim.*.set<Tab>` finds it.

**The wrong reading to reject.** The instinct when you cannot find something is to
leave the editor and search the web, which usually lands you on documentation for a
different Neovim version or on a plugin that reimplements the thing. The help you have
installed matches the Neovim you are running — which for a fast-moving API is the
difference between a correct answer and a confusing one. Lesson 00's version pinning
and this are the same concern. Try the wildcard before the browser.

## Navigating once you are inside

| Key | Does |
|---|---|
| `<C-]>` | follow the tag under the cursor |
| `<C-t>` | go back (a **tag** stack, not the jumplist) |
| `<C-o>` | go back via the jumplist — also works, from lesson 03 |
| `gO` | show a table of contents for this file |
| `:helpclose` / `:helpc` | close the help window |

Measured — starting in `lua.txt`, putting the cursor on the `mapping` reference and
following it:

```
<C-]>   lua.txt:3663  ->  map.txt:15     moved
<C-t>                 ->  lua.txt:3663   back
```

A `|tag|` reference in help text is a hyperlink, and `<C-]>` is the click. Note that
the cursor must be **on the tag text**, not on the surrounding bars.

`gO` is the one people do not know: in any help file it opens a clickable table of
contents for that file. On a 3,000-line file like `options.txt` it is the difference
between scrolling and navigating.

### The help buffer is a buffer

From lesson 10's model, measured:

```
buftype="help"   filetype="help"   modifiable=false   buflisted=false
```

Three consequences worth connecting:

- It is **unlisted**, so `:ls` does not show it and `:ls!` does. That is what the `u`
  flag column in lesson 10 was for.
- It is **not modifiable**, so you cannot accidentally edit the documentation.
- Its `filetype` is `help`, which is how you would later add a mapping that applies
  only inside help — `q` to close, say.

## `:helpgrep` searches the *text*, not the tags

When you do not know the tag and cannot guess a prefix, search the content. And
`:helpgrep` fills the **quickfix list**, so every navigation command from lesson 11
applies unchanged:

```
:helpgrep nvim_buf_set_lines     ->  11 entries

api.txt:451   call nvim_buf_set_lines(buf, 0, -1, v:true, ["test…
api.txt:2712  *nvim_buf_set_lines()*
api.txt:2713  nvim_buf_set_lines({buf}, {start}, {end}, {strict_…
api.txt:2784  This is recommended over |nvim_buf_set_lines()| wh…
```

So: `:helpgrep pattern`, then `:copen`, then `]q` to step through — exactly the
workflow from lesson 11, on documentation instead of source. That reuse is the point:
quickfix is a generic list of places, and help search is one more thing that fills it.

`:helpgrep` takes a Vim pattern, so everything from lesson 08 works — `\v`, `\zs`,
alternation.

## The three pages worth visiting once

Measured destinations:

| Command | Opens | What it is |
|---|---|---|
| `:h index` | `index.txt` | **every** command, by mode. The authoritative list. |
| `:h quickref` | `quickref.txt` | a condensed reference card |
| `:h help-summary` | `usr_02.txt` | how to look things up — the meta page |
| `:h notation` | `helphelp.txt` | what `<C-]>`, `{motion}`, `[count]` mean in the docs |

`:h index` is the one to know exists. When you want to find out whether a keystroke
already does something before you map it, that is the page — organised by mode, which
is how the tag namespace is organised too.

`:h notation` answers a question that silently confuses people: in the docs, `{}`
means required, `[]` means optional, and `CTRL-X` is written where you would type
`<C-x>`.

## `K` is not `:help`

A common mistaken belief. `K` looks up the word under the cursor using
`'keywordprg'`, and the default is **not** the help system:

```
K is mapped to:  ""          not a mapping -- built in
'keywordprg'  =  ":Man"
```

So `K` on a word opens a **man page** by default. In a Lua file that is rarely what
you want, which is why LSP configurations remap `K` to hover documentation, and why
`:h` is what you use for Neovim's own docs.

## Worked example

You half remember that there is a way to set a buffer-local option from Lua, and you
cannot remember the spelling. Four escalating queries, each cheaper than the last one
failing.

**One — guess the tag with completion.** You know it is in the `vim.` namespace:

```
:h vim.bo<Tab>
```

If that lands, you are done in eight keystrokes.

**Two — widen with a wildcard.** If you were wrong about `bo`:

```
:h vim.*option*<Tab>
```

**Three — search the text.**

```
:helpgrep buffer.local option
:copen
]q
```

**Four — go to the index.** For a keystroke rather than a function, `:h index` and
search within it.

**The wrong reading to reject.** It is tempting to skip to step three every time,
since `:helpgrep` always finds *something*. The problem is that it finds too much —
`:helpgrep option` would return hundreds of entries, most of them prose mentions
rather than the definition. Tag completion is precise because a tag is a *definition
point*; `:helpgrep` is a full-text search. Reach for the precise tool first and widen
only when it misses; that ordering is why steps one and two exist.

## Distinctions worth keeping straight

| These look alike | but |
|---|---|
| `:h list` / `:h 'list'` / `:h :list` | the data type / the option / the Ex command |
| `:h CTRL-W` / `:h i_CTRL-W` | Normal mode / Insert mode — different pages |
| `<Tab>` / `<C-d>` on the command line | insert the first match / list all matches |
| tag completion / `:helpgrep` | definition points / full text — precise versus broad |
| `<C-]>` / `<C-o>` | the tag stack / the jumplist — both go back, differently |
| `<C-t>` / `<C-o>` | pop the tag stack / previous jump |
| `gO` / scrolling | a table of contents for this file / hope |
| `K` / `:help` | `'keywordprg'`, which defaults to `:Man` / Neovim's own docs |
| `:h index` / `:h quickref` | every command, by mode / a condensed card |
| help buffer listed / unlisted | it is **unlisted** — `:ls!` shows it, `:ls` does not |
| `{motion}` / `[count]` in docs | required / optional — see `:h notation` |

## Common errors

### `E149: No help for foo`

No tag by that name. Try completion on a prefix of it, or a wildcard, or `:helpgrep`.

### `:h shiftwidth` gave you something unexpected

Options need their quotes: `:h 'shiftwidth'`. Without them you may hit a different
entry or none.

### You looked up `<C-w>` and got window commands when you meant Insert mode

Add the mode prefix: `:h i_CTRL-W`. The docs write control keys as `CTRL-W`, not
`<C-w>` — see `:h notation`.

### `:helpgrep` returned hundreds of entries

It is a full-text search. Narrow the pattern, or use tag completion instead — a tag is
a definition point, which is usually what you actually wanted.

### `<C-]>` said there is no tag

The cursor was on the `|` bars rather than on the tag text inside them, or on a word
that is not a tag reference.

### `K` opened a man page

That is `'keywordprg'` doing its documented job; its default is `:Man`. Use `:h` for
Neovim documentation.

### The help window will not close with `:q` the way you expect

`:helpclose` closes it from anywhere. `:q` works too, but only while you are in it —
and because the help buffer is unlisted, `:bd` on it behaves differently from `:bd` on
a file.

## Check yourself

1. Name four different tags that all contain the word `list`, and say what each
   documents.
2. You want the Insert-mode meaning of `<C-w>`. What do you type?
3. How do you find a function whose name ends in `set` somewhere under `vim.` when you
   do not know the module?
4. Difference between `<Tab>` and `<C-d>` while typing a `:help` argument?
5. `:helpgrep` fills which list, and which lesson's commands therefore navigate it?
6. What does `gO` do in a help file?
7. Why does `:ls` not show the help buffer, and what shows it?
8. What does `K` do by default, and why is that not the help system?
9. When would you prefer tag completion over `:helpgrep`, and why?
10. In the documentation, what is the difference between `{motion}` and `[count]`?

<details><summary>Answers</summary>

1. `list` (the List data type), `'list'` (the option), `:list` (the Ex command), and
   `v_list` does *not* exist — so three real ones plus a reminder that not every
   spelling is a tag. `i_CTRL-W` / `CTRL-W` / `c_CTRL-W` is the same idea for keys.
2. `:h i_CTRL-W` — the mode prefix, and `CTRL-W` rather than `<C-w>`.
3. `:h vim.*.set<Tab>` — the completion accepts wildcards.
4. `<Tab>` inserts the first match and cycles; `<C-d>` lists all the matches without
   inserting anything.
5. The quickfix list, so every command from lesson 11 — `:copen`, `:cnext`, `]q` —
   works on it unchanged.
6. Opens a table of contents for the current help file.
7. The help buffer is unlisted (`buflisted=false`). `:ls!` shows unlisted buffers;
   that is what lesson 10's `u` flag column marks.
8. It looks up the word under the cursor with `'keywordprg'`, whose default is `:Man`
   — so a man page, not Neovim's docs.
9. Almost always first. A tag is a *definition point*, so completion is precise, while
   `:helpgrep` is a full-text search that also returns every passing mention. Widen to
   `:helpgrep` only when the precise query misses.
10. `{}` marks a required argument, `[]` an optional one. `:h notation` documents the
    conventions.

</details>

## Key takeaways

- Punctuation is part of the tag. `list`, `'list'` and `:list` are three different
  entries, and `CTRL-W` exists once per mode. Getting "the wrong page" is a query
  problem, not a documentation problem.
- Completion is the discovery mechanism, and it accepts wildcards — `:h vim.*.set` finds
  a function whose module you have forgotten.
- Escalate: tag completion, then a wildcard, then `:helpgrep`, then `:h index`. Precise
  before broad, because a tag is a definition and a text search is every mention.
- `:helpgrep` fills the quickfix list, so lesson 11's navigation applies unchanged.
- The help buffer is an unlisted, unmodifiable buffer with `filetype=help` — which is
  why `:ls` hides it and why you can give help its own mappings later.
- `K` is `'keywordprg'`, not `:help`, and defaults to `:Man`.
- The help you have installed matches the Neovim you are running. For a fast-moving
  API, that beats a search engine.

## Lookup (not the lesson)

| Tag | For |
|---|---|
| `:h helphelp.txt` | the help system itself — the meta chapter |
| `:h :help` | the command, and `:h :helpclose` |
| `:h :helpgrep` | full-text search into quickfix |
| `:h help-context` | the mode prefixes and the tag conventions |
| `:h notation` | `{}`, `[]`, `CTRL-X` and the rest |
| `:h help-summary` | the official "how to look things up" page |
| `:h index` | every command by mode, and `:h quickref` for the card |
| `:h CTRL-]` | following a tag, and `:h CTRL-T` for the tag stack |
| `:h 'keywordprg'` | what `K` actually does, and `:h K` |
| `:h local-additions` | where a plugin's help appears, and `:h :helptags` to build it |
| `:h 'helplang'` | if you ever want translated help |

Now go to [`TASK.md`](TASK.md).
