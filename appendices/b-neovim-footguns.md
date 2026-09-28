# Appendix B — Neovim and Lua footguns, indexed by symptom

Every entry here has been reproduced in this environment (Neovim 0.12.5, LuaJIT
2.1) and the output is transcribed, not composed. Look yourself up by **symptom**,
not by cause — when you are stuck you do not yet know the cause.

Most of these fail *quietly*. That is what makes them expensive.

This appendix grows as lessons produce entries. Cross-references point at the
lesson that teaches the mechanism properly.

---

## Symptom index

| What you observe | Jump to |
|---|---|
| A keymap using `<leader>` does nothing, or fires on the wrong key | [1](#1-leader-keymaps-fire-on-the-wrong-key) |
| `vim.opt.something` prints a huge table instead of a value | [2](#2-vimopt-returns-an-object-not-a-value) |
| Arithmetic on an option "works" but the result is unusable | [2](#2-vimopt-returns-an-object-not-a-value) |
| An `if` on a `vim.fn` result is always true | [3](#3-zero-is-truthy-so-vimfnhas-checks-always-pass) |
| Off-by-one when reading buffer lines at the cursor | [4](#4-the-api-is-0-indexed-the-cursor-is-not) |
| `E5560: … must not be called in a fast event context` | [5](#5-e5560-fast-event-context) |
| Neovim starts fine but your settings are missing | [6](#6-neovim-started-is-not-my-config-ran) |
| `E5422: Conflicting configs` | [7](#7-e5422-conflicting-configs) |
| An edit leaves a stray space behind | [8](#8-a-delete-left-a-stray-space) |
| `>>` inserted a tab when you wanted spaces | [9](#9-indenting-inserted-a-tab) |

---

## 1. Leader keymaps fire on the wrong key

**Fails silently.** Lesson 23 teaches keymaps; lesson 27 teaches load order.

`<leader>` is **expanded when the keymap is created**, not when you press it. It
is not stored as "leader plus a". Change `mapleader` afterwards and existing maps
keep the old prefix.

Reproduced — two maps created either side of a `mapleader` change, then read back
with `nvim_get_keymap`:

```
lhs=",a" desc=set with comma leader
lhs=";b" desc=set with semicolon leader
```

Both maps exist, on different prefixes, from the same `<leader>` source text.

**Why it bites in a real config:** you set `vim.g.mapleader` in one file and your
keymaps in another, and the keymap file runs first. Every map silently binds to
`\` (the default leader). Nothing errors. Your keys just do nothing.

**Fix:** set `mapleader` before anything that defines a mapping — including
before a plugin manager loads, because plugin specs can declare keys. This is why
a config's option file is required to run before its lazy.nvim bootstrap.

---

## 2. `vim.opt` returns an object, not a value

**Fails loudly, but with a confusing message.** Lesson 18.

`vim.o.x` gives you the plain value. `vim.opt.x` gives you an *Option object*
whose job is to support `:append()`, `:remove()` and `:get()`.

```
vim.o.shiftwidth   -> 8
type(vim.opt.shiftwidth) -> table
vim.opt.shiftwidth:get() -> 8
```

Printing `vim.opt.shiftwidth` dumps a forty-line table with `_info`, `_value` and
a metatable. That is not a bug; it is the object.

The nastier half: the object defines `__add`, so arithmetic **appears** to work.

```
local r = vim.opt.shiftwidth + 1
type = table   (a number would be usable; a table is not)
value= 9
```

The `9` is in there, but `r` is still a table, and the failure surfaces somewhere
unrelated:

```
('%d'):format(vim.opt.shiftwidth)
-> bad argument #2 to '?' (number expected, got table)
```

**Fix:** to *read*, use `vim.o.x` (or `vim.opt.x:get()`). Use `vim.opt` when you
want its list/map methods. `+` on an option means "append", not "add".

---

## 3. Zero is truthy, so `vim.fn.has()` checks always pass

**Fails silently.** Lesson 13 (Lua semantics), lesson 21 (`vim.fn`).

In Lua only `nil` and `false` are falsy. `0` is true. Vimscript functions return
`0` and `1`, not booleans.

```
has("nosuchfeature") = 0
  ...and `if` took the TRUE branch
```

So `if vim.fn.has('nvim-0.99') then` is true on every Neovim ever built, and a
version gate written that way protects nothing.

**Fix:** compare explicitly — `vim.fn.has('nvim-0.12') == 1`. The same applies to
`filereadable()`, `exists()`, `executable()` and every other predicate reached
through `vim.fn`.

---

## 4. The API is 0-indexed, the cursor is not

**Fails silently, usually as an off-by-one.** Lesson 22.

`nvim_buf_get_lines` takes 0-based, end-exclusive indices. `nvim_win_get_cursor`
returns a **1-based** line with a **0-based** column. Same session, same buffer:

```
cursor (1-based line)      = { 2, 0 }
nvim_buf_get_lines(b,1,2)  = { "line two" }
  ^ row 2 of the window is index 1 to the buffer API
```

So the line under the cursor is `nvim_buf_get_lines(0, row - 1, row, false)[1]`.

**The mixed convention inside one return value** — line 1-based, column 0-based —
is the part that catches people who have already learned the 0-based rule.

**Fix:** convert at the boundary and name the variable for its convention
(`row0`, `lnum`). `vim.api.nvim_get_current_line()` avoids the arithmetic
entirely when you only want the cursor's line.

---

## 5. `E5560`: fast event context

**Fails loudly.** Lesson 26.

Callbacks from timers, `vim.uv` handles and some autocommands run in a *fast
event context*, where most of the API is forbidden. Reproduced inside a
`uv.new_timer()` callback:

```
inside timer callback: E5560: nvim_echo must not be called in a fast event context
```

**Fix:** wrap the body in `vim.schedule(function() … end)`, which defers it to the
main loop where the API is legal. The rule of thumb: anything that touches
buffers, windows or messages needs `vim.schedule` when it is reached from a
libuv callback.

---

## 6. "Neovim started" is not "my config ran"

**Fails silently.** Lesson 00.

Neovim reports an error from your config and then **carries on starting**. You get
a working editor with some settings applied and some not, and no ongoing
indication that anything is wrong. The error scrolled past during startup.

**Fix:** set a marker on the last line of `init.lua`:

```lua
vim.g.hero_config_loaded = true
```

Then `:lua = vim.g.hero_config_loaded` distinguishes "ran to completion" from
"started and died half way". Recover the lost error with `:messages`.

---

## 7. `E5422: Conflicting configs`

**Fails loudly, and refuses to start your config at all.** Lesson 00.

```
E5422: Conflicting configs: "/home/n8/.config/hero/init.lua" "/home/n8/.config/hero/init.vim"
```

Both `init.lua` and `init.vim` exist in the config directory. Neovim will not
choose. Common when migrating from Vimscript and creating `init.lua` beside the
old file.

**Fix:** delete or rename one. The message names both paths.

---

## 8. A delete left a stray space

**Fails silently — it is not a bug.** Lesson 01, lesson 02.

Two separate causes, and they need different fixes.

**Cause A: the space was behind the cursor.** An operator only affects text from
the cursor forward. On `the quick brown fox` with the cursor on the `f` of `fox`,
quoted so whitespace is visible:

```
dw -> "the quick brown "
```

The space at the previous column was never in range.

**Cause B: you used an inclusive motion.** `de` deletes exactly the word and
leaves the separator; `dw` takes the separator too.

```
de -> " quick brown fox"
dw -> "quick brown fox"
```

**Fix:** for "delete this word and close the gap", `daw` — the `a` text object
includes the surrounding whitespace regardless of which side the cursor is on:

```
daw at the same cursor position -> "the quick brown"
```

---

## 9. Indenting inserted a tab

**Fails visibly but confusingly.** Lesson 18.

`>>` inserts whatever `'expandtab'` and `'shiftwidth'` say. Under `-u NONE` —
which is how this repo's drill runner starts Neovim — `'expandtab'` is **off**:

```
>> on "flush left"  -> "\tflush left"
expandtab=false shiftwidth=8 tabstop=8
```

So a drill expecting eight spaces fails, and so does a config that assumes
indentation means spaces.

**Fix:** `vim.opt.expandtab = true` if you want spaces, and set `shiftwidth`
alongside it. Note that these are *buffer-local* options in a config that loads
files of several languages — lesson 24's `FileType` autocommands are the right
place for per-language values, not the global option file.
