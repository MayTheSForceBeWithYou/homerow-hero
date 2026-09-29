# 14 — Tables, the only data structure

Lua has one container. Arrays are tables, dictionaries are tables, objects are tables,
modules are tables, and every plugin spec you will write in lesson 28 is a table. That
economy is elegant and it has three consequences that bite: `#` does not mean what you
expect when a table has holes, iteration order is not what you inserted, and assignment
copies a *reference*. All three show up in real configs.

## What this lesson asks of you

Predict `#t` for a table you have not seen, choose between `pairs` and `ipairs` for a
reason, and say when `vim.deepcopy` is necessary rather than merely cautious.

No config work. Nothing is added to `~/.config/hero`.

## One type, two halves

A table has a **list part** (consecutive integer keys from 1) and a **map part**
(everything else). They coexist in the same value:

```lua
local t = { 'a', 'b', 'c', name = 'hero', [10] = 'far' }
```

Measured:

```
#t      = 3        only the list part
t[1]    = a        Lua indexes from 1
t.name  = hero
t[10]   = far      present, but not counted by #
```

`t.name` is sugar for `t['name']` — identical. And `[10] = 'far'` is a real entry that
`#` ignores, because 10 is not part of the consecutive run from 1.

**Lua indexes from 1.** Every Lua-facing thing in Neovim does too. The `vim.api`
functions are the exception, and lesson 22 is where that collision gets its own
treatment — it is worth knowing now that the inconsistency is coming.

## `#` is only defined without holes

This is the first of the three traps, and the documentation is honest about it in a way
people skim past: `#` on a table with a `nil` in the middle may return **any** boundary.

Measured:

```
h = { 1, 2, 3, 4, 5 }; h[3] = nil   ->  #h = 5
h2 = { 1, 2, nil, 4, 5 }            ->  #h2 = 5
```

Both gave 5 here. Both could legally have given 2. The rule is not "it returns the
highest index" — the rule is that **the result is unspecified**, and depending on it
is a bug that will surface when a table grows or the implementation changes.

So: `#` is trustworthy on a table with no holes, and meaningless on one with holes. The
practical habit is to not create holes. Use `table.remove` (which shifts) rather than
assigning `nil` into the middle.

## `pairs` versus `ipairs`

| Iterator | Visits | Stops |
|---|---|---|
| `ipairs(t)` | `t[1]`, `t[2]`, … | at the **first `nil`** |
| `pairs(t)` | **every** key | when there are none left |

Measured on `{ 1, 2, nil, 4, 5 }`:

```
ipairs -> 1=1 2=2                  stopped at the hole
pairs  -> 1=1 2=2 4=4 5=5          found everything
```

So `ipairs` is for a list you believe is dense, and `pairs` is for everything else. If
`ipairs` is silently processing two of your five entries, you have a hole.

### `pairs` order is unspecified — and that is worse than "wrong"

The second trap, and the measurement is more interesting than the usual telling.

Running the *same* program three times, inserting eight keys one at a time and then
iterating:

```
session 1   inserted: one two three four five six seven eight
            iterated: one two three four five six seven eight     matches
session 2   iterated: one two three four five six seven eight     matches
session 3   iterated: eight one two three four five six seven     does not
```

Within a single session the order is **stable** — iterating the same table three times in
one process gave identical results every time. Across sessions it **varies**, because
LuaJIT seeds its string hashing per process.

So the danger is not that `pairs` order is wrong. It is that it is often *right*, and then
one day is not. A config that iterates a map and depends on the order works for weeks and
then breaks on a restart, with nothing changed. That is a far worse failure than one that
breaks immediately.

From a literal, in one session:

```
{ zebra = 1, apple = 2, mango = 3 }  ->  iterated: apple mango zebra
```

Treat the order as unspecified, because it is.

To iterate a map predictably you sort the keys yourself:

```lua
local keys = vim.tbl_keys(t)
table.sort(keys)
for _, k in ipairs(keys) do
  -- …
end
```

Measured: that gives `apple mango zebra` reliably.

The **list** half does iterate in order, which is the entire reason `ipairs` exists.

**The wrong reading to reject.** Having seen an iteration come out in insertion order,
the natural conclusion is that Lua "mostly" preserves order and that sorting is
belt-and-braces. Two of the three sessions above *did* come out in insertion order — and
that is the trap, not the reassurance. Relying on behaviour that is usually right is how
you get a bug that appears months later on a machine you cannot reproduce. Where order is
visible to anyone — a list of keymaps you print, options you apply in sequence — sort it
or use a list. Where it is not visible, do not spend the sort.

## Tables are references

The third trap, and the one that causes the strangest bugs.

```
a = { 1, 2 };  b = a;  b[1] = 99
  ->  a[1] = 99          the same table
  ->  a == b  is true
  ->  { 1 } == { 1 }  is false
```

Assignment copies a *reference*, so `b` is not a copy — it is another name. And `==` on
tables compares identity, not contents: two tables with identical contents are not
equal.

### Shallow versus deep copies

`vim.tbl_extend('force', {}, t)` gives you a new **top-level** table whose values are
the same references. Measured:

```
orig = { nested = { x = 1 } }

shallow = vim.tbl_extend('force', {}, orig)
shallow.nested.x = 99    ->  orig.nested.x = 99      the nested table is shared

deep = vim.deepcopy(orig)
deep.nested.x = 77       ->  orig.nested.x = 1       independent
```

That is the rule for when `vim.deepcopy` is *necessary* rather than cautious: when the
table has nested tables you intend to modify. For a flat table of options a shallow
copy is genuinely enough, and `deepcopy` on a large structure is not free.

## The `vim.tbl_*` family

Neovim ships table helpers, and knowing they exist saves reinventing them. All measured:

| Call | Result |
|---|---|
| `vim.tbl_extend('force', {a=1,b=1}, {b=2})` | `{ a = 1, b = 2 }` — later wins |
| `vim.tbl_extend('keep', {a=1,b=1}, {b=2})` | `{ a = 1, b = 1 }` — earlier wins |
| `vim.tbl_deep_extend('force', {a={x=1,y=2}}, {a={y=9}})` | `{ a = { x = 1, y = 9 } }` — merges nested |
| `vim.tbl_keys({a=1,b=2})` | `{ "b", "a" }` — a list, in unspecified order |
| `vim.tbl_count({a=1,b=2})` | `2` — counts **all** keys, unlike `#` |
| `vim.tbl_isempty({})` | `true` |
| `vim.list_extend({1}, {2,3})` | `{ 1, 2, 3 }` — appends in place |
| `vim.list_slice({1,2,3,4}, 2, 3)` | `{ 2, 3 }` |

Three of those deserve emphasis.

**`vim.tbl_count` counts everything**, where `#` counts only the list part. For a map,
`#t` is 0 and `vim.tbl_count(t)` is the answer you wanted.

**`force` versus `keep`** is the whole vocabulary of option merging, and it is the
mechanism behind every plugin's "your settings override the defaults" — lesson 28's
`opts` tables are merged exactly this way.

**`tbl_deep_extend` merges nested tables** rather than replacing them, which is the
difference between overriding one field of a nested config and losing its siblings.

## Worked example

You are writing a helper that takes an options table and fills in defaults — the shape
every plugin uses.

```lua
local defaults = {
  width = 80,
  border = 'rounded',
  keys = { close = 'q', accept = '<CR>' },
}

local function setup(opts)
  opts = vim.tbl_deep_extend('force', defaults, opts or {})
  -- …
end
```

Three decisions in that one line, each from this lesson.

**`deep` rather than plain `extend`.** With plain `tbl_extend`, a caller passing
`{ keys = { close = 'x' } }` would replace the whole `keys` table and lose `accept`.
`deep` merges it, so `accept` survives.

**`'force'` rather than `'keep'`.** The caller's values must win over the defaults —
that is what "options" means. `keep` would silently ignore everything they passed.

**`opts or {}`** so that `setup()` with no argument works.

And now the bug that is not visible in that snippet. `vim.tbl_deep_extend` returns a new
table, so `defaults` is safe. But write it the other way:

```lua
local function setup_broken(opts)
  opts = vim.tbl_extend('force', opts or {}, defaults)   -- wrong order AND aliasing
end
```

**The wrong reading to reject.** It is tempting to mutate the defaults table directly —
`for k, v in pairs(opts) do defaults[k] = v end` — because it looks simpler and it
works the first time. It works exactly once. `defaults` is a single table shared by
every call, so the second caller inherits the first caller's options, and the module's
"defaults" drift away from what the source says. This is the reference trap with a
module-level table, and it is one of the commonest real bugs in plugin configuration
code. The fix is the one above: build a new table and never write into `defaults`.

## Distinctions worth keeping straight

| These look alike | but |
|---|---|
| list part / map part | consecutive integers from 1 / every other key, in one table |
| `t.name` / `t['name']` | identical — the first is sugar |
| `#t` / `vim.tbl_count(t)` | the list part only / every key |
| `#t` with holes / without | **unspecified** / the length |
| `ipairs` / `pairs` | dense list, stops at the first `nil` / every key |
| `pairs` order / insertion order | unspecified: stable per session, varies between them, and sometimes identical |
| `a = b` / `vim.deepcopy(b)` | another name for the same table / an independent one |
| `a == b` / same contents | identity / not compared |
| `tbl_extend` / `tbl_deep_extend` | replaces nested tables / merges them |
| `'force'` / `'keep'` | later argument wins / earlier one wins |
| `table.remove(t, i)` / `t[i] = nil` | shifts, no hole / leaves a hole and breaks `#` |
| Lua 1-indexed / `vim.api` 0-indexed | everything here / the collision in lesson 22 |

## Common errors

### `#t` returned 0 for a table that clearly has entries

They are all in the map part. `#` counts only the list part; use `vim.tbl_count(t)`.

### A loop processed two of five entries

`ipairs` with a hole. It stops at the first `nil`. Use `pairs`, or do not create the
hole — `table.remove` shifts, assigning `nil` does not.

### `#t` gave a different answer than you expected after removing an item

You assigned `nil` into the middle, so `#t` is now unspecified. Both the old and the new
answer are legal.

### Your keymaps applied in a different order than you wrote them

You iterated a map with `pairs`. Sort the keys, or use a list of pairs instead of a
table keyed by lhs.

### Changing one table changed another

They are the same table. Assignment copies a reference. Use `vim.deepcopy` if you need
independence, and check whether a nested table is shared — a shallow copy shares them.

### A module's defaults changed over time

Something wrote into the defaults table instead of building a new one. Merge into a
fresh table: `vim.tbl_deep_extend('force', defaults, opts)`.

### `vim.tbl_extend` lost half a nested table

It replaces nested tables rather than merging. Use `vim.tbl_deep_extend`.

### `vim.tbl_extend` complained about a `nil` argument

Every argument must be a table. `opts or {}` is the idiom for an optional parameter.

## Check yourself

1. For `{ 'a', 'b', name = 'x', [9] = 'y' }`, what is `#t` and why?
2. What does `#t` return for a table with a `nil` in the middle?
3. Give the two things `ipairs` does that `pairs` does not.
4. Is `pairs` order the insertion order? What did the three-session measurement show,
   and why is that result worse than a consistent mismatch?
5. How do you iterate a map in a predictable order?
6. `a = { 1 }; b = a; b[1] = 2`. What is `a[1]`, and why?
7. Is `{ 1 } == { 1 }` true?
8. When is `vim.deepcopy` necessary rather than merely cautious?
9. Difference between `tbl_extend` and `tbl_deep_extend`, and when does it matter?
10. What is wrong with `for k, v in pairs(opts) do defaults[k] = v end`?

<details><summary>Answers</summary>

1. `2`. Only the consecutive integer keys from 1 count; `name` and `[9]` are in the map
   part.
2. Unspecified. Any boundary is a legal answer — the measurement gave 5, and 2 would
   also have been correct.
3. It visits only consecutive integer keys from 1, and it stops at the first `nil`.
4. It is unspecified. Two of three sessions matched insertion order exactly and the
   third did not — stable within a session, varying between them. That is worse than a
   consistent mismatch, because code relying on it works until it suddenly does not.
5. Collect the keys with `vim.tbl_keys`, `table.sort` them, then `ipairs` the sorted
   list.
6. `2`. Assignment copies a reference, so `a` and `b` name the same table.
7. No. `==` on tables compares identity, not contents.
8. When the table contains nested tables you intend to modify. A shallow copy shares
   them, so mutating the copy mutates the original.
9. `tbl_extend` replaces a nested table wholesale; `tbl_deep_extend` merges it. It
   matters whenever a caller overrides one field of a nested table and expects the
   siblings to survive.
10. It writes into the module-level `defaults` table, which is shared by every call. The
    second caller inherits the first caller's options and the defaults drift from what
    the source says. Build a new table instead.

</details>

## Key takeaways

- One container, two halves. `#` measures the list part only, and `vim.tbl_count`
  measures everything.
- `#` on a table with holes is **unspecified**, not "the highest index". Avoid holes:
  `table.remove` shifts, `t[i] = nil` does not.
- `ipairs` stops at the first `nil`; `pairs` sees every key. If a loop is doing less
  than you expect, look for a hole.
- `pairs` order is stable within a session and varies between them. It is often
  *identical* to insertion order, which is what makes relying on it dangerous rather than
  merely wrong. Sort the keys when the order is visible to anyone.
- Assignment copies a reference, and `==` compares identity. A shallow copy shares
  nested tables; `vim.deepcopy` does not.
- `'force'` and `'keep'` are the vocabulary of option merging, and `tbl_deep_extend` is
  what stops an override from deleting its siblings.
- Never write into a module-level defaults table. Merge into a new one.

## Lookup (not the lesson)

| Tag | For |
|---|---|
| `:h lua-table` | how Neovim treats a table crossing into Vimscript |
| `:h luaref-table` | the Lua reference for the `table` library |
| `:h luaref-pairs` | and `:h luaref-ipairs` |
| `:h luaref-tableinsert` | and `:h luaref-tableremove`, `:h luaref-tableconcat` |
| `:h luaref-tablesort` | sorting, for predictable map iteration |
| `:h vim.tbl_extend()` | and `:h vim.tbl_deep_extend()` — the merge modes |
| `:h vim.deepcopy()` | independent copies |
| `:h vim.tbl_keys()` | and `:h vim.tbl_values()`, `:h vim.tbl_count()` |
| `:h vim.tbl_isempty()` | and `:h vim.tbl_contains()` |
| `:h vim.tbl_filter()` | and `:h vim.tbl_map()` |
| `:h vim.list_extend()` | and `:h vim.list_slice()` |
| `:h vim.islist()` | telling a list from a map |
| `:h vim.iter()` | the modern iterator chain, once you want more than these |

Now go to [`TASK.md`](TASK.md).
