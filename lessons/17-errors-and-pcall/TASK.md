# 17 — Task

Practice only. The teaching is in [`LESSON.md`](LESSON.md).

**This lesson changes `~/.config/hero`.** The reference snapshot is `config/17`. This is the
last lesson of Phase D.

## 1. Add the helper, and use it for nothing yet

In `~/.config/hero/`:

1. Create `lua/hero/util.lua` returning a table with an `optional(name)` function that
   `pcall`s a require, returns the module on success, and on failure notifies at `DEBUG`
   with the **captured error text** before returning `nil`.
2. Leave the two `require` calls in `hero/init.lua` **unguarded**, and write a comment
   saying why.

**Done when** `:lua = require('hero.util').optional('nope')` returns `nil` and
`:messages` shows your notification naming the module and the reason.

Compare afterwards: `bash tools/use-snapshot.sh --diff 17`.

The comment in step 2 is the real deliverable. In six months you will look at two
unguarded requires next to a helper designed for guarding them and assume it is an
oversight.

## 2. Watch a config half-load

1. In `hero/options.lua`, insert `error('deliberate')` in the middle — after `mapleader`,
   before some options.
2. Restart `hero`.
3. `:= vim.g.hero_config_loaded` — what does it say?
4. `:set shiftwidth?` — did the options after the error apply?
5. `:= vim.g.mapleader` — did the ones before it?
6. `:messages` — find the error.
7. Now move the `error` to *above* the `mapleader` line and repeat. Press `<leader>y`.

Step 7 is the one worth doing slowly: an error in the wrong place gives you a config where
every mapping is on the wrong key, and nothing on screen says so.

Remove the error when you are done.

## 3. Decide, for each line, whether failure is survivable

Go through your **real** config (`~/.config/nvim/`) and for every `require` and every
`pcall` you find, write one of:

- **required** — a failure should stop the chunk
- **optional** — a failure should be survived *and reported*
- **wrong** — currently guarded but should not be, or vice versa

You are looking for two things: a `pcall` whose message is discarded, and a guard around
something that everything after it depends on.

## 4. Get a traceback out of a protected call

```lua
local function inner() error('deep') end
local function outer() inner() end
```

1. `pcall(outer)` and print the second value. Count the lines.
2. `xpcall(outer, debug.traceback)` and print it. Read it bottom-up.
3. Now put a real failing call from your own config in place of `inner` and do the same.

Then answer: why can the handler see the stack when `pcall` cannot?

## 5. Learn the level argument by needing it

Write a validation helper:

```lua
local function set_width(n)
  if type(n) ~= 'number' then
    error('width must be a number')
  end
end
```

1. Call it with a string from another function. Note which file and line the error blames.
2. Change the `error` to use level `2`. Call it again. Note the difference.
3. Decide which you would want if the helper were in `hero/util.lua` and the bad call were
   in `hero/keymaps.lua`.

## 6. Prove the falsy rule to yourself

```vim
:lua print(pcall(function() return assert(0) end))
:lua print(pcall(function() return assert('') end))
:lua print(pcall(function() return assert(false) end))
:lua print(pcall(function() return assert(nil) end))
```

Two pass and two fail. Then find, in your own config or in a plugin, a truthiness check on
a `vim.fn` result that would be wrong for the same reason — lesson 00's drill 10 is the
pattern.

## 7. Drills

```bash
./drill 17
```

Eighteen drills; two are `BUG HUNT`. Drill 17 is unusual in that the "bug" is a judgement
error rather than a mistake — the broken version is code a careful person writes on purpose.

**Done when** `./drill 17` reports no `TODO` and no `FAIL`.

## 8. Write one drill

Add `exercises/19-mine-*.lua` for something this lesson mentioned but did not drill:
`vim.F.npcall`, an error raised inside a `vim.schedule` callback (and where it surfaces),
`select` on a `pcall` that returns several values, or `vim.health` reporting. If you stub
`vim.notify`, restore it before your assertions run — the runner does not reset it.
