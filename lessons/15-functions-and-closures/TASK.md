# 15 — Task

Practice only. The teaching is in [`LESSON.md`](LESSON.md).

Nothing in this lesson changes `~/.config/hero`.

## 1. Drills

```bash
./drill 15
```

Twenty drills; two are `BUG HUNT`.

Read 08, 09 and 10 as a set: the same closure-in-a-loop question with three answers, and
the difference is only how many variables existed. Then 19 is that bug as it actually
appears in configuration code.

Drills 11 and 12 are the same function call in two positions. Predict drill 12 before
running it.

**Done when** `./drill 15` reports no `TODO` and no `FAIL`.

## 2. Hunt for your own accidental globals

Install the detector in a scratch `:lua` session:

```lua
setmetatable(_G, {
  __newindex = function(_, k) error(('accidental global: %s'):format(k), 2) end,
})
```

Then source your **real** config's files one at a time with `:source` and see whether
anything raises. Remove the metatable afterwards with `setmetatable(_G, nil)`.

If nothing raises, good. If something does, you have found a typo that has been sitting
there. Either way you now know what a strict-mode plugin does.

## 3. Prove the two function forms differ

Write both, with a recursive call inside each:

```lua
local function a(n) … a(n-1) … end
local b = function(n) … b(n-1) … end
```

Call both. Read the error from the second one carefully and note the word it uses for
`b`. That word is the diagnostic you will actually use when a `local` behaves as though
it is missing.

Then fix `b` without changing it to form A. (There are two ways.)

## 4. Feel the ordering rule

In a scratch file, write:

```lua
local function top() return bottom() end
local function bottom() return 'hi' end
print(top())
```

1. Run it. Record the error.
2. Swap the two definitions. Run it again.
3. Restore the original order and fix it with a forward declaration instead.
4. Now make them mutually recursive — `top` calls `bottom`, `bottom` calls `top` with a
   base case — and get that working.

Step 4 is the one that shows why forward declaration exists rather than being a style
preference.

## 5. Build something with private state

Write a closure-based helper you would actually use. Some options:

- a toggler that remembers the previous value of an option
- a function that returns the next item from a list each time it is called, cycling
- a counter that reports how many times a keymap has been pressed this session

Then answer, for your helper: how many copies of the captured local should exist, and is
that where you declared it? Make a second instance and confirm they do not interfere.

## 6. Map the truncation rule

Write a function returning three values and put a call to it in each of these positions.
Record how many values survive:

```lua
local t = { f() }
local t = { f(), 9 }
local t = { 9, f() }
print(f())
print(f(), 'x')
print('x', f())
local a, b, c = f()
local a, b, c = f(), 9
return f()
```

Then state the rule in your own words in one sentence. The last two are worth doing even
though they look obvious.

## 7. Read the scoping chapter

```vim
:h luaref-langLocal
```

Answer from the page: exactly where does a local's scope begin, and where does it end?

Then `:h luaref-langVarargs` and answer: what does `select('#', ...)` return that
`#{...}` cannot, and why?

## 8. Write one drill

Add `exercises/21-mine-*.lua` for something this lesson covered but did not drill:
mutual recursion via forward declaration, a closure over a *table* rather than a number
(and what that means for the reference rule from lesson 14), `select(n, ...)` with a
positive index, or `vim.F.if_nil`. If your answer is a statement rather than a value, use
the line form with a `-- TODO_GUARD`.
