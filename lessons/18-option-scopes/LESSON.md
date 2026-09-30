# 18 — Option scopes: `vim.opt`, `vim.o`, `vim.go`, `vim.bo`, `vim.wo`

Phase E opens with a debt. Lesson 04 set options with `vim.opt` and said that reading them
back is not as simple as it looks, and that there are four other tables that differ in ways
that matter. This is that lesson. There are two questions underneath: **which scope does a
writer touch**, and **why does `vim.opt` hand back an object instead of a value**. Both are
measurable, and guessing at either produces the option bugs that are hardest to find.

## What this lesson asks of you

Given an option and an intent — "for this buffer", "for every new buffer", "for this
window" — pick the right table without guessing, and read an option's value back correctly.

This lesson changes `~/.config/hero`. The reference snapshot is `config/18`.

## Every option has a scope, and you can ask

Three scopes, plus a modifier. Measured with `nvim_get_option_info2`:

```
shiftwidth   scope=buf     global_local=false
expandtab    scope=buf     global_local=false
filetype     scope=buf     global_local=false
number       scope=win     global_local=false
wrap         scope=win     global_local=false
list         scope=win     global_local=false
hlsearch     scope=global  global_local=false
shell        scope=global  global_local=false
statusline   scope=win     global_local=true
```

- **`buf`** — each buffer has its own value. `shiftwidth`, `expandtab`, `filetype`.
- **`win`** — each window has its own. `number`, `wrap`, `list`.
- **`global`** — one value for everything. `hlsearch`, `shell`.
- **`global_local`** — a local value that may be *unset*, falling back to a global one.

Stop guessing which is which:

```vim
:= vim.api.nvim_get_option_info2('shiftwidth', {}).scope
```

The scope is why `expandtab` set in one buffer does not affect another, and why `hlsearch`
set anywhere affects everything. Measured — two buffers and two windows really do disagree:

```
vim.bo[b1].expandtab = true   vim.bo[b2].expandtab = false   independent
vim.wo[w1].number    = true   vim.wo[w2].number    = false   independent
```

## The five tables, and exactly which scopes each one writes

This is the table to keep. Measured on `shiftwidth`, a buffer-scoped option, resetting both
scopes to 8 before each writer:

| Writer | local | global | Equivalent to |
|---|---|---|---|
| `vim.o.shiftwidth = 2` | **2** | **2** | `:set` |
| `vim.opt.shiftwidth = 2` | **2** | **2** | `:set` |
| `vim.opt_local.shiftwidth = 2` | **2** | 8 | `:setlocal` |
| `vim.opt_global.shiftwidth = 2` | 8 | **2** | `:setglobal` |
| `vim.bo.shiftwidth = 2` | **2** | 8 | `:setlocal` |
| `vim.go.shiftwidth = 2` | 8 | **2** | `:setglobal` |

And the Ex commands, for comparison, measured in the same harness:

```
:set shiftwidth=2        local=2  global=2
:setlocal shiftwidth=2   local=2  global=8
:setglobal shiftwidth=2  local=8  global=2
```

**`vim.o` and `vim.opt` both behave like `:set`: they write *both* scopes.** That is the
single most useful row in the table and the one people get wrong — including, on the first
draft of this lesson, its author. The intuition that `vim.o` is "the local one" and `vim.go`
is "the global one" is half right: `vim.go` is global-only, but `vim.o` is *both*.

Why it matters: setting `shiftwidth` with `vim.o` inside a `FileType` autocommand (lesson
24) changes the global default too, so the *next* buffer you open — of any filetype —
inherits it. Measured: after `vim.o.shiftwidth = 4` in one buffer, a brand-new buffer came
up with `4`, because a new buffer inherits the **global** value.

**So: `vim.bo` / `vim.opt_local` for per-buffer settings, and `vim.opt` / `vim.o` only for
your global defaults.** That one rule prevents a whole category of "why is this file
indented like the last one" confusion.

## Global-local options

`global_local = true` means the local value can be **unset**, in which case the global one
applies. `statusline` is the common example. Measured:

```
global statusline = 'GLOBAL'
w1 with a local set     ->  "WINLOCAL"
w2 with no local        ->  "GLOBAL"      falls back
w1 after setting its local to ''  ->  "GLOBAL"   the empty string restores the fallback
```

That last line is the part worth knowing: for a global-local *string* option, assigning
`''` does not mean "empty statusline" — it means "go back to using the global". If you want
a genuinely empty one you need the global to be empty too.

## Why `vim.opt` returns an object

Here is the debt from lesson 04, paid. Measured:

```
type(vim.o.shiftwidth)     = number
type(vim.opt.shiftwidth)   = table
vim.opt.shiftwidth:get()   = 8
```

`vim.opt.x` is an **Option object**, not a value. It exists because some options are lists
or maps, and a plain string is a bad interface for them. The object gives you methods:

```lua
vim.opt.wildignore = { '*.o', '*.pyc' }      -- a Lua list, joined for you
vim.opt.wildignore:append('*.so')
vim.opt.wildignore:prepend('*.a')
vim.opt.wildignore:remove('*.pyc')
```

Measured at each step:

```
assign a list  ->  "*.o,*.pyc"
:append('*.so')->  "*.o,*.pyc,*.so"
:prepend('*.a')->  "*.a,*.o,*.pyc,*.so"
:remove('*.pyc')-> "*.a,*.o,*.so"
:get()         ->  { "*.a", "*.o", "*.so" }
```

`:append` and `:remove` are the whole reason `vim.opt` exists. Doing that with strings means
comma-splicing by hand and getting the separators wrong.

For a **map**-style option, `:get()` returns pairs:

```
vim.opt.listchars:get()  ->  { nbsp = "+", tab = "> ", trail = "-" }
```

### The trap

Because it is an object, it is not a number — and it defines `__add`, so arithmetic
*appears* to work:

```
vim.opt.shiftwidth + 1              ->  a table, whose _value is 9
string.format('%d', vim.opt.shiftwidth)
  ->  bad argument #2 to '?' (number expected, got table)
```

`+` on an Option means **append**, not add. The failure surfaces later, wherever the value
is finally used, which is why this is worth a paragraph rather than a footnote.

**The wrong reading to reject.** After being bitten once, the natural conclusion is that
`vim.opt` is a trap to avoid and `vim.o` is the safe choice. That gives up the list methods
and, worse, it hides the scope question behind a table that writes *both* scopes. The rule
that actually works is a division of labour: **`vim.opt` to write** (especially lists),
**`vim.o` or `:get()` to read**, and `vim.bo`/`vim.wo` when the scope matters. Reaching for
`vim.opt` to *read* is the mistake, not `vim.opt` itself.

## Reading an option correctly

Four ways, and they answer different questions:

```lua
vim.o.shiftwidth                                         -- effective value here
vim.go.shiftwidth                                        -- the global default
vim.bo[bufnr].shiftwidth                                 -- one specific buffer
vim.api.nvim_get_option_value('shiftwidth', { buf = 3 }) -- explicit, any scope
```

`nvim_get_option_value` is the one to use when you want to be unambiguous — it takes
`{ scope = 'global' }`, `{ buf = n }`, `{ win = n }`, and it is what the measurements in
this lesson were taken with. Lesson 22 covers the `nvim_` family properly.

And from lesson 04, the question no Lua table answers: *which file set this?*

```vim
:verbose set shiftwidth?
```

## Worked example

A `FileType` autocommand that sets indentation for Lua files. The mechanism is lesson 24's;
the scope decision is this lesson's.

```lua
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lua',
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.expandtab = true
  end,
})
```

`vim.bo`, not `vim.o`. Both work in the sense that the Lua file gets two-space indents.
The difference appears afterwards: with `vim.o`, the global default is now 2, so the next
Makefile you open — which wants tabs — starts from 2 as well, and you spend a while
believing the Makefile has a filetype problem.

For the **window**-scoped equivalent, `vim.wo`:

```lua
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.wo.wrap = true
    vim.wo.linebreak = true
  end,
})
```

**The wrong reading to reject.** It is tempting to conclude that `vim.bo` is simply the
better table and to use it everywhere. It is not: for your *global defaults* — the ones in
`hero/options.lua` that every buffer should start from — `vim.bo` would set only the buffer
that happens to exist at startup, and every buffer opened afterwards would fall back to
Neovim's default. The two tables answer two genuinely different questions, and the
discriminating one is *"should a buffer opened later inherit this?"* If yes, it is a global
default and `vim.opt` is right. If no, it belongs in an autocommand with `vim.bo`.

## Distinctions worth keeping straight

| These look alike | but |
|---|---|
| `vim.o` / `vim.go` | writes **both** scopes, like `:set` / global only, like `:setglobal` |
| `vim.o` / `vim.bo` | both scopes / this buffer only |
| `vim.opt` / `vim.opt_local` | `:set` / `:setlocal` |
| `vim.opt_local` / `vim.bo` | the same effect; `vim.bo` is the plainer spelling |
| `vim.opt.x` / `vim.o.x` | an Option **object** / the value |
| `vim.opt.x + 1` / `vim.o.x + 1` | appends, and yields a table / arithmetic |
| `vim.opt.x:get()` / `vim.o.x` | both read; `:get()` unpacks lists into a table |
| scope `buf` / `win` | per buffer / per window — ask `nvim_get_option_info2` |
| `global_local` false / true | the local always applies / the local may be unset and fall back |
| `''` on a global-local string | restores the global fallback, not an empty value |
| a global default / a per-filetype setting | `vim.opt` at startup / `vim.bo` in an autocommand |
| `:set x?` / `:verbose set x?` | the value / the file that set it |

## Common errors

### A new buffer inherited an indent setting from the last file you opened

Something set a buffer-scoped option with `vim.o` or `vim.opt`, which writes the global
default too. Use `vim.bo` in the autocommand.

### `vim.bo.shiftwidth = 2` in your options module had no effect on later buffers

`vim.bo` writes only the current buffer. Global defaults belong in `vim.opt`.

### `attempt to perform arithmetic on a table value`, or `number expected, got table`

You read `vim.opt.x` where a value was wanted. Use `vim.o.x`, or `vim.opt.x:get()`.

### Your option "worked" but a later calculation was wrong by one

`vim.opt.x + 1` is an **append**, not an addition. It returns an Option whose value happens
to look right in `_value` and which is not a number.

### Setting a global-local string option to `''` did not make it empty

For a global-local option, an empty local means "use the global". Set the global too.

### You cannot tell why an option has the value it has

`:verbose set x?` names the file. A Lua table cannot tell you this.

### Two windows showing the same file disagree about `number`

Correct — `number` is window-scoped. Use `vim.wo` per window, or set the global default.

### `vim.opt.listchars = 'tab:> '` lost your other listchars

Assigning replaces. Use `:append` on the Option object, which is what it is for.

## Check yourself

1. Name the three scopes and the modifier, and the command that tells you which an option
   has.
2. Which scopes does `vim.o.shiftwidth = 2` write? And `vim.go`?
3. Which Ex command is `vim.opt_local` equivalent to?
4. Why does setting `shiftwidth` with `vim.o` inside a `FileType` autocommand cause trouble
   later?
5. What does `vim.opt.x` return, and why is it not a value?
6. What does `vim.opt.wildignore + '*.o'` do?
7. Two ways to read `shiftwidth` as a number.
8. For a global-local option, what does an empty local value mean?
9. Where do global defaults belong, and where do per-filetype settings belong?
10. Which question does no Lua option table answer?

<details><summary>Answers</summary>

1. `buf`, `win`, `global`, plus the `global_local` modifier.
   `vim.api.nvim_get_option_info2('name', {}).scope`.
2. `vim.o` writes **both** the local and the global value, like `:set`. `vim.go` writes only
   the global, like `:setglobal`.
3. `:setlocal`.
4. Because it writes the global default as well, so every buffer opened afterwards — of any
   filetype — inherits that value.
5. An Option object. It exists so that list and map options can have `:append`,
   `:prepend`, `:remove` and `:get` rather than being spliced as strings.
6. Appends — `+` on an Option means append, not add. The result is an Option, not a number.
7. `vim.o.shiftwidth`, or `vim.opt.shiftwidth:get()`. (Also
   `nvim_get_option_value('shiftwidth', {})`.)
8. That the global value applies. Assigning `''` to a global-local string restores the
   fallback rather than making it empty.
9. Global defaults in `vim.opt` at startup; per-filetype settings in a `FileType`
   autocommand using `vim.bo` or `vim.wo`.
10. Which file set the value. That is `:verbose set x?`.

</details>

## Key takeaways

- Options have a scope — `buf`, `win` or `global` — plus a `global_local` modifier. Ask
  `nvim_get_option_info2` rather than guessing.
- **`vim.o` and `vim.opt` write both scopes, like `:set`.** `vim.bo`/`vim.wo` and
  `vim.opt_local` are local-only; `vim.go` and `vim.opt_global` are global-only.
- The practical rule: `vim.opt` for global defaults, `vim.bo`/`vim.wo` in autocommands for
  per-buffer and per-window settings. The question is whether a buffer opened later should
  inherit it.
- `vim.opt.x` is an Option object so that lists get `:append`, `:prepend`, `:remove` and
  `:get`. Write with it; read with `vim.o.x` or `:get()`.
- `+` on an Option appends. It is not addition, and the failure surfaces far from the cause.
- For a global-local option, an empty local means "use the global".
- No Lua table tells you which file set an option. `:verbose set x?` does.

## Lookup (not the lesson)

| Tag | For |
|---|---|
| `:h lua-options` | the whole model, and the table of tables |
| `:h vim.opt` | the Option object, and `:h vim.opt:append()`, `:h vim.opt:get()` |
| `:h vim.o` | and `:h vim.go`, `:h vim.bo`, `:h vim.wo` |
| `:h vim.opt_local` | and `:h vim.opt_global` |
| `:h global-local` | the modifier, and what an unset local means |
| `:h :setlocal` | and `:h :setglobal`, `:h :set` — the Ex equivalents |
| `:h local-options` | which options are local to what |
| `:h nvim_get_option_value()` | the unambiguous reader, and `:h nvim_set_option_value()` |
| `:h nvim_get_option_info2()` | asking an option about itself |
| `:h option-summary` | every option, with its scope |

Now go to [`TASK.md`](TASK.md).
