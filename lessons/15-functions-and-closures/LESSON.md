# 15 — Functions, closures, and `local`

Functions in Lua are values, which is why lesson 23 can hand one to `vim.keymap.set` and
lesson 24 to an autocommand. Getting there needs three things straight: how `local`
actually scopes (including the ordering rule that surprises everyone once), what a
closure captures, and how multiple return values behave — because they are silently
truncated in a position you will definitely write.

## What this lesson asks of you

Write a function that keeps private state, explain why a `local` declared below its use
is invisible, and say what `{ f(), 9 }` contains when `f` returns three values.

No config work. Nothing is added to `~/.config/hero`.

## `local` by default, and the trap if you forget

A bare assignment creates a **global**. No declaration, no warning:

```lua
local function leaky()
  oops = 42
end
leaky()
```

Measured afterwards: `_G.oops` is `42`. That value now lives for the rest of the session,
visible to every plugin and every other file.

This is the footgun lesson 13's chunk rule hinted at. It matters more here because a
config is many files: a typo'd variable name in one plugin file becomes a global that
another file can read, and the bug appears far from its cause.

**The rule: `local` on everything, every time.** The exceptions are deliberate ones — a
value you *intend* to share, which belongs under `vim.g` (lesson 19) rather than in the
global Lua namespace.

### Catching them

A metatable on `_G` turns an accidental global into an immediate error. Measured:

```lua
setmetatable(_G, {
  __newindex = function(_, k) error(('accidental global: %s'):format(k), 2) end,
  __index    = function(_, k) error(('undeclared global read: %s'):format(k), 2) end,
})

sneaky = 1              ->  accidental global: sneaky
return nonexistent      ->  undeclared global read: nonexistent
```

This is what the "strict mode" plugins do. It is worth knowing the mechanism even if you
never install one, because it explains what those plugins are doing and why they
sometimes break code that reads an unset global on purpose.

## Two ways to write a function, and they differ

```lua
local function f() end          -- form A
local f = function() end        -- form B
```

Nearly identical, with one real difference: **form A can call itself.** Measured:

```
local function fact(n) … return n * fact(n-1) end
  ->  works

local fact = function(n) … return n * fact(n-1) end
  ->  fails: attempt to call global 'fact' (a nil value)
```

Form A declares the local *before* compiling the body, so the body can see it. Form B
compiles the body first, while `fact` is still undeclared — so the name inside resolves
to a global, which is `nil`.

Read that error message again: **`attempt to call global 'fact'`**. The word *global* is
the tell. When you see it for a name you thought was local, you have hit either this or
the ordering rule below.

## A `local` exists only below its declaration

This is the ordering rule, and it is the one that catches people arranging a config file.

```lua
local function a() return b() end   -- b is not declared yet
local function b() return 1 end
a()
```

Measured: `attempt to call global 'b' (a nil value)`. At the moment `a`'s body was
compiled, `b` was not a local, so the reference became a global lookup.

The fix is a **forward declaration**:

```lua
local b                              -- declare it now
local function a() return b() end     -- the body captures that local
b = function() return 1 end           -- fill it in later
a()                                   -- works, returns 1
```

Measured: works.

Two practical consequences for a config:

- **Define helpers above the code that uses them.** The usual top-of-file arrangement is
  not style; it is a requirement.
- **Mutual recursion needs a forward declaration.** Two functions that call each other
  cannot both be declared after the other.

## Closures capture variables, not values

A function that references a local from an enclosing scope keeps that variable alive.
The captured variable is an **upvalue**.

```lua
local function counter()
  local n = 0
  return function()
    n = n + 1
    return n
  end
end
```

Measured — two independent counters:

```
c1 = counter();  c2 = counter()
c1() c1() c1()  ->  1 2 3
c2()            ->  1          independent
```

Each *call* to `counter` creates a fresh `n`, so each returned function has its own. That
is private state with no table and no object system, and it is how you write a keymap
callback that remembers something between presses.

### The loop question, measured both ways

The classic puzzle, and the answer depends on where the variable lives.

```lua
local fns = {}
for i = 1, 3 do fns[i] = function() return i end end
  ->  1 2 3
```

Each iteration of a numeric `for` gets a **fresh** `i`, so each closure captured a
different variable.

```lua
local fns2, j = {}, 0
while j < 3 do j = j + 1; fns2[j] = function() return j end end
  ->  3 3 3
```

Here `j` is declared **outside** the loop, so all three closures captured the *same*
variable — and by the time they ran, it was 3.

**The wrong reading to reject.** The common belief is that Lua closures capture by value
and the `3 3 3` result means something exotic happened. Nothing exotic happened: both
loops captured a variable, and the difference is purely **how many variables there
were**. The numeric `for` made three; the `while` made one. When you see every callback
in a generated set behaving as though it were the last one, look for a single variable
shared by all of them — and the fix is to introduce a new local inside the loop body.

## Multiple return values, and the truncation

A function can return several values, and where you put the call decides how many
survive. All measured, with `multi()` returning `1, 2, 3`:

```
{ multi() }        ->  { 1, 2, 3 }     last position: all of them
{ multi(), 9 }     ->  { 1, 9 }        NOT last: truncated to one
select(2, multi()) ->  2
```

Look at the second line. `{ multi(), 9 }` is a two-element table, and the `2` and `3` are
gone with no warning. A multi-value expression is **adjusted to one value** unless it is
the last item in a list — in a table constructor, an argument list, or a `return`.

This is the rule behind a whole family of confusing bugs:

```lua
print(multi(), 'end')        -- prints 1 end
print('start', multi())      -- prints start 1 2 3
```

Same call, different position, different number of values.

### Varargs

`...` collects the extra arguments. Two ways to use it, and one of them is unreliable:

```
select('#', 1, nil, 3)   ->  3      counts the nil
#{ 1, nil, 3 }           ->  1      the nil breaks # (lesson 14)
```

So **`select('#', ...)` is the correct way to count varargs**, and `#{...}` is not,
because a `nil` argument produces a hole and lesson 14 established that `#` on a table
with holes is unspecified. `table.pack` would help — it does not exist in 5.1 (measured).

`...` outside a vararg function does not compile at all:

```
local function f() return ... end
  ->  cannot use '...' outside a vararg function near '...'
```

## Method syntax: the colon passes `self`

```lua
local obj = { n = 5 }
function obj:get() return self.n end        -- colon: self is implicit
function obj.plain(self) return self.n end  -- dot: self is explicit
```

Measured:

```
obj:get()        ->  5
obj.plain(obj)   ->  5
obj.get()        ->  fails: attempt to index local 'self' (a nil value)
```

`obj:get()` is sugar for `obj.get(obj)`. The colon in the *definition* adds a hidden
`self` parameter; the colon in the *call* passes the receiver. Mix them up and you get
that `self` is nil error — which, by lesson 13's rule, is a name problem: `self` exists
but holds nothing.

You will meet this mostly when reading plugin code. A module that returns a table of
plain functions (lesson 16's shape) does not need it.

## Worked example

A keymap callback that toggles something and remembers its state. This is the shape
lesson 23 will bind to a key.

```lua
local function make_toggler(option)
  local saved = nil                      -- private, one per toggler

  return function()
    if saved == nil then
      saved = vim.o[option]
      vim.o[option] = not saved
    else
      vim.o[option] = saved
      saved = nil
    end
  end
end

local toggle_wrap = make_toggler('wrap')
```

Three things from this lesson are doing work there.

**`saved` is an upvalue**, so the returned function has state without a global and
without a table. Call `make_toggler` twice and you get two independent togglers —
measured behavior from the counter above.

**`local function` and the ordering rule**: `make_toggler` must be defined above
`toggle_wrap`.

**It returns a function**, which is a value like any other — the whole reason
`vim.keymap.set` can take it.

**The wrong reading to reject.** The tempting simplification is a module-level
`local saved` shared by every toggler:

```lua
local saved = nil                        -- WRONG: one variable for all togglers
local function make_toggler(option) …
```

It works while you have one toggler and breaks silently when you add a second — the two
share `saved`, so toggling `wrap` and then `number` restores the wrong value into the
wrong option. This is the `3 3 3` result from the loop measurement, wearing different
clothes: one variable where you needed one per closure. The question to ask of any
captured local is *how many of these should exist?*, and then to declare it at that
scope.

## Distinctions worth keeping straight

| These look alike | but |
|---|---|
| `x = 1` / `local x = 1` | creates a **global**, silently / a local |
| `local function f` / `local f = function` | the body can call `f` / it cannot |
| `attempt to call global 'f'` | a local you expected — either form B or the ordering rule |
| declared above / below the use | visible / a global lookup that finds `nil` |
| `local b` then `b = …` | a forward declaration, which fixes mutual recursion |
| a fresh local per iteration / one outer local | `1 2 3` / `3 3 3` |
| capture by value / capture the **variable** | Lua does the second |
| `{ f() }` / `{ f(), 9 }` | every value / **one** value, silently |
| `#{...}` / `select('#', ...)` | breaks on a `nil` argument / correct |
| `obj:get()` / `obj.get()` | passes `obj` as `self` / `self` is nil |
| `function obj:m()` / `function obj.m(self)` | identical — the colon is sugar |
| a global for shared state / `vim.g` | pollutes the Lua namespace / namespaced (lesson 19) |

## Common errors

### `attempt to call global 'foo' (a nil value)` for something you declared `local`

Either you wrote `local foo = function …` and the body calls itself, or the declaration
is *below* the use. The word **global** in the message is the clue.

### A helper works at the bottom of the file and not at the top

A `local` exists only below its declaration. Move the helper up, or forward-declare it.

### Two functions that call each other will not both resolve

Forward-declare one: `local b` on its own line, then define `a`, then assign `b`.

### Every generated callback behaves like the last one

They all captured the same variable. Declare the captured local *inside* the loop body so
each iteration gets its own.

### A table constructor lost values from a function call

The call was not in the last position, so it was adjusted to one value. Move it last, or
capture the values first.

### `#` on a vararg table gave the wrong count

A `nil` argument left a hole. Use `select('#', ...)`.

### `cannot use '...' outside a vararg function`

The enclosing function was not declared with `...` in its parameter list.

### `attempt to index local 'self' (a nil value)`

A method defined with `:` was called with `.`, so nothing was passed as `self`. Call it
with `:`, or pass the receiver explicitly.

### Something set a global you never wrote

Search for an assignment missing its `local`. A metatable on `_G` makes the next one
raise at the moment it happens.

## Check yourself

1. What does `x = 1` do at the top level of a config file?
2. Which of the two function forms can recurse, and why?
3. Why does a helper defined at the bottom of a file fail when used at the top, and what
   is the message?
4. How do you make two mutually recursive local functions work?
5. `counter()` called twice gives two functions. Do they share `n`?
6. A numeric `for` capturing `i` gave `1 2 3`; a `while` capturing an outer `j` gave
   `3 3 3`. Explain both.
7. `f` returns `1, 2, 3`. What is `{ f(), 9 }`?
8. Why is `select('#', ...)` correct where `#{...}` is not?
9. `obj:get()` is sugar for what?
10. You need state shared across your whole config. Where does it go, and why not a
    global?

<details><summary>Answers</summary>

1. Creates a global, silently. It lives for the session and is visible to every file and
   plugin.
2. `local function f` — it declares the local before compiling the body, so the body can
   see the name. `local f = function` compiles the body while `f` is still undeclared, so
   the name inside resolves to a global.
3. A `local` exists only below its declaration, so the reference compiled to a global
   lookup that finds `nil`. The message is `attempt to call global 'name' (a nil value)`.
4. Forward-declare: `local b` on its own line, then define `a` (whose body captures that
   local), then assign `b = function…`.
5. No. Each call to `counter` creates a fresh `n`, so each returned function has its own
   upvalue.
6. A numeric `for` creates a new variable each iteration, so there were three variables
   to capture. The `while` loop's `j` was declared outside it, so all three closures
   captured one variable, which held 3 by the time they ran.
7. `{ 1, 9 }`. A multi-value call is adjusted to one value unless it is last.
8. `select('#', ...)` counts the arguments including any `nil`. `#{...}` builds a table
   first, and a `nil` argument leaves a hole, which makes `#` unspecified (lesson 14).
9. `obj.get(obj)`.
10. Under `vim.g` (lesson 19), because it is namespaced and visible to Vimscript too. A
    Lua global pollutes a namespace shared with every plugin and is the thing a typo
    creates by accident.

</details>

## Key takeaways

- A bare assignment makes a global. `local` on everything; share deliberately through
  `vim.g`.
- `local function f` can recurse; `local f = function` cannot. `attempt to call global`
  for a name you thought was local means one of that or the ordering rule.
- A `local` exists only below its declaration, so helpers go above their use and mutual
  recursion needs a forward declaration.
- Closures capture the **variable**, not its value. `1 2 3` versus `3 3 3` is a question
  of how many variables existed, not of capture semantics.
- A multi-value call keeps all its values only in the **last** position. `{ f(), 9 }` has
  two elements.
- `select('#', ...)` counts varargs correctly; `#{...}` does not, because a `nil`
  argument makes a hole.
- The colon is sugar for passing the receiver, and `self` being nil is a name problem.

## Lookup (not the lesson)

| Tag | For |
|---|---|
| `:h luaref-functions` | the chapter, and `:h luaref-langFuncDef` for the forms |
| `:h lua-scope` | how Neovim describes Lua scoping |
| `:h luaref-langLocal` | `local` and its ordering rule |
| `:h luaref-langClosures` | upvalues |
| `:h luaref-langVarargs` | `...`, and `:h luaref-select` for `select('#', …)` |
| `:h luaref-langMethods` | the colon, and what it desugars to |
| `:h luaref-_G` | the global table |
| `:h luaref-setmetatable` | the mechanism behind the accidental-global detector |
| `:h vim.F` | small helpers such as `vim.F.if_nil`, once you want them |

Now go to [`TASK.md`](TASK.md).
