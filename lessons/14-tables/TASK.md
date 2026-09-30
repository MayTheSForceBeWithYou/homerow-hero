# 14 — Task

Practice only. The teaching is in [`LESSON.md`](LESSON.md).

Nothing in this lesson changes `~/.config/hero`.

## 1. Drills

```bash
./drill 14
```

Twenty drills; two are `BUG HUNT`. Drills 13 and 14 are the same override done shallowly
and deeply, and 19 and 20 are the two reference traps met in the wild. Drill 19 is worth
sitting with even after you fix it — the broken version is code people ship.

**Done when** `./drill 14` reports no `TODO` and no `FAIL`.

## 2. Predict `#t` before you look

Write these in a scratch buffer and, for each, say what `#t` will be *before* running
`:= #t`:

```lua
{ 'a', 'b', 'c' }
{ 'a', 'b', name = 'x' }
{ [1] = 'a', [2] = 'b', [4] = 'd' }
{ [0] = 'zero', 'one' }
{}
{ nil, 'b' }
```

Then check each with `:=`. The fourth and sixth are the interesting ones. Where you were
wrong, work out why from the list-part rule rather than memorising the answer.

## 3. Make a hole and watch it break things

```lua
local t = { 1, 2, 3, 4, 5 }
```

1. `:= #t`
2. `t[3] = nil`
3. `:= #t` — did it change?
4. Count with `ipairs`. Count with `pairs`. Explain the difference.
5. Start again and use `table.remove(t, 3)` instead. Check `#t` and both counts.

Step 3's answer is *allowed* to differ from what you get. Note what you got and remember
that another Lua build may answer differently — that is what "unspecified" means.

## 4. Prove the order claim yourself

Build a map of ten keys one at a time, recording the order you inserted them. Iterate
with `pairs` and compare.

Then do it again with different key names. And again with keys that are numbers as
strings (`'1'`, `'2'`, …).

You are looking for the case that most surprises you. Then answer: in your own config,
is there anywhere the order of a `pairs` loop is visible to you or to a user?

## 5. Feel the reference trap

```lua
local a = { list = { 1, 2 }, n = 1 }
local b = a
local c = vim.tbl_extend('force', {}, a)
local d = vim.deepcopy(a)
```

Now mutate through each of `b`, `c`, `d` — both a top-level field (`n`) and a nested one
(`list[1]`) — and after each, check `a`. Build the four-by-two table of results.

That table is the whole of this section, and it is worth keeping.

## 6. Read the merge modes properly

```vim
:h vim.tbl_deep_extend()
```

Answer from the page:

1. What are all the valid behaviour strings, not just `force` and `keep`?
2. What happens if you pass a non-table argument?
3. Does it modify its arguments, or return a new table? Which argument, if any, is at
   risk?

Then find a plugin spec in your real config (`~/.config/nvim/lua/plugins/`) that has an
`opts` table, and say which merge mode lazy.nvim must be using for your settings to
override the plugin's defaults. Lesson 28 confirms it.

## 7. Write one drill

Add `exercises/21-mine-*.lua` for a table behaviour this lesson listed but did not drill:
`vim.tbl_filter`, `vim.tbl_map`, `vim.tbl_contains`, `vim.tbl_values`, `table.sort` with
a comparator, `table.concat` with a separator, or `vim.iter`. If your answer is a
*statement* rather than a value, use the line form with a `-- TODO_GUARD` above it rather
than the `ANSWER_BEGIN` block — `AUTHORING.md` explains why.
