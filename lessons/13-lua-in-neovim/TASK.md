# 13 — Task

Practice only. The teaching is in [`LESSON.md`](LESSON.md).

Nothing in this lesson changes `~/.config/hero`. This is the first lesson of Phase D.

## 1. Drills

```bash
./drill 13
```

Twenty drills; two are `BUG HUNT`. Drill 19 is unusual: it reports **BROKEN** rather
than FAIL, because `//` is a *parse* error and takes the whole file down before any of
it runs. That is the point — a single `//` anywhere in a config file costs you the
entire file, which no amount of `pcall` can rescue.

**Done when** `./drill 13` reports no `TODO`, no `FAIL` and no `BROKEN`.

## 2. Build the `:=` habit

Open `hero`. For the next twenty minutes, answer every question about Neovim's state by
asking it rather than guessing:

```vim
:= vim.version()
:= vim.o.shiftwidth
:= vim.fn.getcwd()
:= vim.api.nvim_get_mode()
:= vim.fn.getqflist()
:= _VERSION
:= jit.version
```

Notice which of those render across several lines and which stay on one. That is
`vim.inspect` telling you whether you are looking at a list or a map — a distinction
lesson 14 is entirely about.

## 3. Prove the version difference to yourself

Run each of these **both ways** and write down the two answers:

| Snippet |
|---|
| `print(7 // 2)` |
| `print(math.type(1))` |
| `print(tostring(3.0))` |
| `print(string.format('%d', 7/2))` |
| `print(table.unpack({1,2,3}))` |
| `print(_VERSION)` |

```bash
lua -e 'SNIPPET'                                  # the system Lua: 5.5
nvim --headless -u NONE -c 'lua SNIPPET' -c qa    # what your config actually runs
```

The fourth row is the one to sit with: one truncates silently, the other raises. If you
had verified that snippet in the shell, you would have shipped a bug you could not see.

Then put the second command somewhere you will find it — a shell alias, a note. You
will want it for every remaining lesson in this course.

## 4. Read errors on purpose

Produce each of the four codes deliberately and record the exact message:

1. A parse error typed at `:lua`.
2. A runtime error typed at `:lua`.
3. A parse error in a file you `:source`.
4. A runtime error in a file you `:source`.

For each, answer before moving on: which code, and does a file need fixing?

Then produce a traceback with three frames — a function calling a function calling
`error()` — and read it aloud from the bottom up.

## 5. Distinguish a name error from an argument error

```vim
:lua vim.api.nvim_buf_set_lines()
:lua vim.api.nvim_no_such_thing()
```

Both fail. Read both messages and say which one is a *name* problem and which is an
*argument* problem. The phrase `(a nil value)` is the tell.

This matters because the two need opposite responses: a name error sends you to
`:h` (lesson 12), and an argument error sends you to the function's signature.

## 6. Feel the chunk boundary

```vim
:lua local x = 1
:lua print(x)
:lua y = 1
:lua print(y)
```

Then answer: if `local` does not survive between commands, how do two *files* in a
config share anything? Guess, write your guess down, and check it against lesson 16
when you get there.

## 7. Write one drill

Add `exercises/21-mine-*.lua` for a version difference this lesson did not drill:
`setfenv`, `loadstring`, `math.pow`, `table.getn`, the `bit` library, `goto`, or
`require('ffi')`. Assert on presence or absence rather than on behaviour where you can,
and remember that a *syntax* difference must be tested with `load()` rather than
`pcall()` — a parse error happens before anything runs.
