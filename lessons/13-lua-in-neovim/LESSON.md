# 13 — Lua in Neovim

Phase D turns from keystrokes to code. Before any of the `vim.` object model makes
sense you need three things: how to run Lua at all, what a *chunk* is and why a local
vanishes between two commands, and — the one that costs people an afternoon — **which
Lua this is**. It is not the Lua on your `PATH`, and the difference is not academic.

## What this lesson asks of you

Evaluate an expression, inspect a table, read a Lua traceback, and name three things
the Lua inside Neovim cannot do that the `lua` on your `PATH` can.

No config work. Nothing is added to `~/.config/hero`.

## Five ways to run Lua

| How | When |
|---|---|
| `:lua {code}` | one statement, typed |
| `:lua= {expr}` or `:={expr}` | evaluate and print the result |
| `:luafile {file}` | run a file |
| `:source {file}` | run a file — `.lua` files are run as Lua |
| `init.lua` | at startup step 8 (lesson 00) |

Measured — all three print forms work and are worth knowing, because `:=` is three
characters:

```
:lua =1+1                 ->  2
:lua= vim.o.shiftwidth    ->  8
:=2*3                     ->  6
```

`:=` is the one to build a habit on. It is the Lua equivalent of a REPL prompt and you
will use it constantly to ask Neovim what it thinks.

`:luafile` and `:source` behave identically on a `.lua` file — measured, the same
runtime error from the same file reports the same way through either. Prefer `:source`,
since it also handles Vimscript and is what lesson 04's reload loop used.

## Chunks: why your `local` disappeared

Each `:lua` command is compiled as its own **chunk** — an independent unit of code.
A `local` belongs to the chunk that declared it, and the chunk ends when the command
does.

Measured:

```
:lua local scoped = 42
:lua print(tostring(scoped))     ->  nil

:lua global_here = 42
:lua print(tostring(global_here)) ->  42
```

So a `local` does not survive to the next command and a global does. That is not a
quirk of `:lua`; it is how Lua chunks work, and the same rule explains why a `local`
at the top of one config file is invisible to another (lesson 16).

**The wrong reading to reject.** The tempting conclusion is "so use globals in the
command line, it is easier". It works, and it is how you will poke at things
interactively — but it is also how config files accumulate accidental globals that
collide, which lesson 15 is about. The habit worth having: globals are fine for a
throwaway `:lua` probe, and `local` everywhere in a file. If you need state across two
`:lua` commands, put it under `vim.g` (lesson 19) where it is at least namespaced.

## Which Lua is this?

**Neovim runs LuaJIT 2.1, which is Lua 5.1 plus some extensions.** Measured inside
Neovim:

```
_VERSION      = Lua 5.1
jit present   = true
jit.version   = LuaJIT 2.1.1788856981
```

And on the same machine, at a shell prompt:

```
$ lua -v
Lua 5.5.1
```

Those are two different languages for several purposes. The system `lua` is **not** a
usable REPL for checking config idioms, and this is the single most common way people
waste an evening in Phase D.

### What is missing

Measured, inside Neovim:

| You write | LuaJIT does |
|---|---|
| `7 // 2` | **compile error** — `unexpected symbol near '/'` |
| `local x <close> = …` | **compile error** — `unexpected symbol near '<'` |
| `local x <const> = 1` | **compile error** |
| `math.type(1)` | **nil** — attempt to call field 'type' |
| `math.maxinteger` | `nil` |
| `table.unpack` | **missing** — the 5.1 name is the global `unpack` |

### What is present that 5.4 removed

| Available here | Status in 5.4+ |
|---|---|
| `unpack` (global) | renamed `table.unpack` |
| `loadstring` | removed; use `load` |
| `setfenv` | removed |
| `table.getn` | removed |
| `math.pow` | removed |

So code written for either version can fail on the other, in both directions.

### What LuaJIT adds

`require('ffi')` and the `bit` library are both available, and `goto`/labels compile
(a 5.2 feature LuaJIT adopted). Bitwise operators work too — `5 & 3` gives `1`. You
will rarely need any of this in a config, but it explains why some plugins are
LuaJIT-only.

### The trap that is worst because it is silent

There is no integer/float distinction in 5.1. Everything is a double.

```
10/2            ->  5        not 5.0
7/2             ->  3.5
tostring(3.0)   ->  "3"      5.3+ prints "3.0"
"x" .. 10/2     ->  "x5"
```

And then:

```
string.format('%d', 7/2)
  LuaJIT (in Neovim) ->  3                                    silently truncated
  lua 5.4 / 5.5      ->  ERROR: bad argument #2 to 'string.format'
                                (number has no integer representation)
```

Read those two lines again. The *same expression* truncates quietly in your config and
raises loudly in the REPL you might have used to check it. If you develop a habit of
verifying snippets with `lua -e`, this is the class of bug you will ship.

**The rule for the rest of this course: verify Lua idioms through Neovim.**

```bash
nvim --headless -u NONE -c 'lua print(7 // 2)' -c qa
```

That is four words longer than `lua -e` and it is the only version that tells you the
truth about your config.

## Printing and inspecting

`print` works, but it stringifies a table as an address. `vim.inspect` renders its
contents, and `vim.print` is `print` with `vim.inspect` applied.

Measured:

```
vim.inspect({ a = 1 })   ->  {
                               a = 1
                             }
vim.inspect({ 1, 2, 3 }) ->  { 1, 2, 3 }
```

Note that `vim.inspect` formats a **list** on one line and a **map** across several —
which is itself a quick way to see which half of a table you have (lesson 14).

`:lua= expr` applies `vim.inspect` for you, which is why `:=` is the right tool for
looking at a table:

```
:= vim.version()
:= vim.fn.getqflist()[1]
```

## Reading an error

Four error codes, and the grid is worth learning because it tells you *where* to look
before you read the message. All measured:

|  | parse error | runtime error |
|---|---|---|
| typed at `:lua` | **E5107** | **E5108** |
| in a file or chunk | **E5112** | **E5113** |

```
:lua local x = = 1
E5107: Lua: [string ":lua"]:1: unexpected symbol near '='

:lua error("x")
E5108: Lua: [string ":lua"]:1: x

:source parse13.lua
E5112: Lua chunk: /tmp/parse13.lua:3: unexpected symbol near '<eof>'

:source bad13.lua
E5113: Lua chunk: /tmp/bad13.lua:2: attempt to index local 'x' (a number value)
```

Two recognition rules:

**`[string ":lua"]` is the chunk name.** When you see it, the error came from a typed
command, not from a file — so a stale `:lua` you ran earlier is a candidate, and there
is no file to go and fix.

**A parse error's line number can be one past the mistake.** The `E5112` above reports
line 3 of a two-line file: Lua read to the end of input still expecting something. When
a parse error names the last line, look at the line before it.

### Tracebacks read bottom-up

```
E5113: Lua chunk: /tmp/bad13b.lua:1: boom
stack traceback:
	[C]: in function 'error'
	/tmp/bad13b.lua:1: in function 'inner'
	/tmp/bad13b.lua:2: in function 'outer'
	/tmp/bad13b.lua:3: in main chunk
```

Read it from the **bottom**: the main chunk called `outer` at line 3, which called
`inner` at line 2, which called `error` at line 1. The top line is where it broke; the
bottom is where it started. Lesson 17 goes further into this, including how to get a
traceback out of a `pcall`.

## Worked example

You want to know what a `vim.` function returns, without reading documentation first.

```vim
:= vim.fn.getcwd()
```

prints a string. Now something structured:

```vim
:= vim.api.nvim_get_mode()
```

prints a table, rendered across lines because it is a map.

Now suppose it errors. You typed:

```vim
:lua = vim.api.nvim_get_current_lines()
```

and got:

```
E5108: Lua: [string ":lua"]:1: attempt to call field 'nvim_get_current_lines' (a nil value)
```

Work the message rather than guessing. `E5108` says runtime, at `:lua` — so no file is
involved. "attempt to call field … (a nil value)" means the *name does not exist*,
not that the arguments are wrong. So the question is what it is actually called, which
is lesson 12's job:

```vim
:h nvim_*lines<Tab>
```

**The wrong reading to reject.** The instinct on "attempt to call a nil value" is to
assume the function needs different arguments, and to start trying them. It does not:
Lua resolved the name to `nil` before any call happened, so the arguments were never
looked at. Distinguishing *"this name does not exist"* from *"this call was wrong"* is
most of reading Lua errors, and the phrase to key on is **`(a nil value)`** — that is
always a name problem.

## Distinctions worth keeping straight

| These look alike | but |
|---|---|
| the `lua` on your `PATH` / Neovim's Lua | 5.5 here / **LuaJIT 2.1, i.e. 5.1** |
| `7 // 2` / `math.floor(7/2)` | a compile error here / the portable spelling |
| `unpack` / `table.unpack` | the 5.1 global, present / the 5.4 name, **missing** |
| `10/2` printing `5` / `5.0` | no integer type in 5.1 / 5.3+ has one |
| `string.format('%d', 7/2)` | silently truncates here / raises in 5.4+ |
| `print` / `vim.print` | table as an address / table rendered |
| `:lua` / `:lua=` | run a statement / evaluate and show |
| `:luafile` / `:source` | equivalent for `.lua`; `:source` also does Vimscript |
| a `local` across two `:lua` / a global | gone / persists |
| E5107 / E5108 | parse / runtime, both at `:lua` |
| E5112 / E5113 | parse / runtime, both in a file |
| `[string ":lua"]` / a filename | typed command / a real file to go and fix |
| top of a traceback / bottom | where it broke / where it started |

## Common errors

### `E5107: … unexpected symbol near '/'`

You wrote `//`. Integer division does not exist in 5.1 — use `math.floor(a/b)`.

### `E5107: … unexpected symbol near '<'`

A `<close>` or `<const>` attribute. Neither exists in 5.1.

### `attempt to call field 'type' (a nil value)` on `math.type`

`math.type` is 5.3+. There is no integer/float distinction to report.

### `attempt to call field 'unpack' (a nil value)` on `table.unpack`

Use the global `unpack` in LuaJIT. If you want code that works in both, guard it:
`local unpack = table.unpack or unpack`.

### Your snippet worked in `lua -e` and fails in Neovim, or vice versa

Two different languages. Verify with
`nvim --headless -u NONE -c 'lua …' -c qa`.

### `string.format('%d', x)` produced a truncated number and no error

`x` was not a whole number, and LuaJIT truncates silently where 5.4 raises. Use `%s`,
or `math.floor` deliberately so the intent is visible.

### `print(t)` showed `table: 0x7f…`

That is a table's address. Use `vim.print(t)` or `:= t`.

### A parse error points at a line that looks fine

Look at the line *before*. Lua reports where it ran out of input, which for an
unterminated construct is the end of the file.

### You cannot find where `attempt to index a nil value` happened

Read the traceback from the bottom up. The lowest frame is your entry point and the
highest is the failure.

## Check yourself

1. Which Lua does Neovim run, and what does `_VERSION` report?
2. Give three things the system `lua 5.5` can do that Neovim's Lua cannot.
3. Why does a `local` set in one `:lua` command not exist in the next?
4. What is the portable way to write integer division here?
5. `string.format('%d', 7/2)` — what happens here, and what happens in 5.4?
6. You see `E5108` with `[string ":lua"]` in it. What two things do you now know?
7. What is the difference between E5112 and E5113?
8. A traceback has four frames. Which end is the failure?
9. `attempt to call field 'foo' (a nil value)` — is this an argument problem?
10. What is the one-line command that verifies a Lua idiom the way your config will see
    it?

<details><summary>Answers</summary>

1. LuaJIT 2.1, which is Lua 5.1 plus extensions. `_VERSION` reports `Lua 5.1`.
2. Any three of: `//` integer division, `<close>`/`<const>` attributes, `math.type`,
   `math.maxinteger`, `table.unpack`, and raising on `string.format('%d', 3.5)`.
3. Each `:lua` command is its own chunk, and a `local` belongs to the chunk that
   declared it. The chunk ends when the command does. A global persists because it
   lives in the global table instead.
4. `math.floor(a / b)`.
5. Here it silently truncates to `3`. In 5.4 and 5.5 it raises
   *bad argument #2 to 'string.format' (number has no integer representation)*.
6. That it is a **runtime** error, not a parse error; and that it came from a typed
   `:lua` command rather than from a file, so there is no file to go and fix.
7. Both are errors in a file or chunk: E5112 is a **parse** error, E5113 a **runtime**
   one.
8. The top frame is where it broke; the bottom is where it started. Read bottom-up.
9. No. Lua resolved the name to `nil` before any call happened, so the arguments were
   never examined. `(a nil value)` is always a name problem.
10. `nvim --headless -u NONE -c 'lua …' -c qa`

</details>

## Key takeaways

- Neovim runs **LuaJIT 2.1 — Lua 5.1 plus extensions** — not the `lua` on your `PATH`.
  Verify idioms with `nvim --headless -u NONE -c 'lua …' -c qa`, never `lua -e`.
- `//`, `<close>`, `<const>`, `math.type` and `table.unpack` do not exist here;
  `unpack`, `loadstring`, `setfenv` and `math.pow` do, and 5.4 removed them.
- There is no integer type, so `10/2` is `5` and `string.format('%d', 7/2)` truncates
  **silently** where a modern Lua raises. That asymmetry is the expensive one.
- Each `:lua` is its own chunk: locals do not survive to the next command, globals do.
- `:=` is your REPL. It applies `vim.inspect`, so it renders tables rather than
  printing addresses.
- The error grid tells you where to look before you read the message: E5107/E5108 for a
  typed `:lua` (parse/runtime), E5112/E5113 for a file. `[string ":lua"]` means there is
  no file involved.
- `(a nil value)` in an error is always a name problem, never an argument problem.
- Tracebacks read bottom-up.

## Lookup (not the lesson)

| Tag | For |
|---|---|
| `:h lua-guide` | the official orientation, and `:h lua.txt` for the reference |
| `:h :lua` | the command, and `:h :lua=` for the print form |
| `:h :luafile` | running a file, and `:h :source` |
| `:h vim.print()` | and `:h vim.inspect()` |
| `:h lua-error` | how Lua errors surface as Vim errors |
| `:h E5107` | and `:h E5108`, `:h E5112` — the codes |
| `:h vim.version()` | checking the Neovim version from Lua |
| `:h luaref` | the Lua 5.1 reference manual, bundled |
| `:h lua-vimscript` | the bridge, which lessons 20 and 21 cover properly |

Now go to [`TASK.md`](TASK.md).
