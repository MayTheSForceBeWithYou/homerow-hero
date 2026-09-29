# 17 — Errors, `pcall`, and the half-loaded config

Lesson 00 put a flag on the last line of `init.lua` and claimed that "Neovim started" is a
weaker statement than "my config ran". This lesson is why. An error stops the **chunk** it
occurred in and leaves Neovim running, so a config can be half applied with no ongoing
sign of it. `pcall` is how you choose which failures are survivable — and the interesting
part is that guarding everything is the wrong answer.

## What this lesson asks of you

Decide, for a given line of config, whether its failure should be survivable; write the
guard if it should; and get a traceback out of a protected call when you need one.

This lesson changes `~/.config/hero`. The reference snapshot is `config/17`.

## `pcall`: run something and get a verdict

```lua
local ok, result = pcall(f, arg1, arg2)
```

`ok` is a boolean. On success `result` is the return value; on failure it is the error.
Measured:

```
pcall(function() return 'fine' end)    ->  ok=true   value="fine"
pcall(function() error('boom') end)    ->  ok=false  value="pc.lua:5: boom"
```

Note the error carries a **file and line**. That is `error` prepending position
information, not `pcall` adding it.

A protected call passes through every return value:

```
pcall(multi)  ->  ok=true then 1 2 3
```

### `pcall` catches errors, not failure

This distinction matters more than it looks:

```
pcall(function() return nil end)  ->  ok=true  value=nil
```

A function that signals failure by *returning* `nil` has not errored, so `ok` is `true`.
Many `vim.fn` functions work that way. `pcall` tells you whether something *raised*; it
does not tell you whether it worked.

## `error` and `assert`

```lua
error('message')        -- raise, with position information prepended
error('message', 0)     -- raise, with no position information
error({ code = 42 })    -- raise a table
```

Measured:

```
error('plain')      ->  "pc.lua:10: plain"
error('plain', 0)   ->  "plain"
error({code = 42})  ->  a table, with code = 42 intact
```

Use `0` when the message is for a user rather than a programmer — a position is noise in
`E5108: Lua: …/hero/util.lua:14: expected a buffer number`. And a **table** error survives
unchanged, which is how you pass structured information to a caller that will inspect it.

The second argument is a **level**, and it decides which line gets blamed:

```
error('lvl1', 1)   ->  "pc.lua:18: lvl1"     the line that called error (default)
error('lvl2', 2)   ->  "lvl2"                the caller of that function
```

Level 2 is what you want in a validation helper: the useful line number is the caller's,
not your helper's. That is why lesson 15's accidental-global detector used `error(…, 2)`.

`assert` is `error` with a condition:

```
assert(false)                  ->  "pc2.lua:4: assertion failed!"
assert(false, 'my message')    ->  "pc2.lua:5: my message"
assert(42, 'never seen')       ->  returns 42
```

Two things worth keeping. **`assert` returns its value on success**, so
`local x = assert(f())` both checks and binds. And `assert(0)` **passes**, because 0 is
truthy in Lua — the same trap as lesson 00's `vim.fn.has()` drill.

## `pcall` throws away the traceback

The cost of protecting a call is that you lose the stack. Measured on a two-deep failure:

```
pcall(outer)   ->  pc.lua:26: deep
```

One line. Where it was called from is gone. `xpcall` takes a handler that runs **while the
stack still exists**:

```lua
local ok, err = xpcall(outer, debug.traceback)
```

```
pc.lua:26: deep
stack traceback:
	[C]: in function 'error'
	pc.lua:26: in function 'inner'
	pc.lua:27: in function <pc.lua:27>
	[C]: in function 'xpcall'
	pc.lua:29: in main chunk
```

Read it bottom-up, as lesson 13 established. This is the tool for "something in my config
throws and I cannot tell what called it".

## The half-loaded config, demonstrated

A file with an error in the middle:

```lua
vim.g.probe_first = true
error('stop here')
vim.g.probe_last = true
```

Sourced, measured:

```
raised = true
probe_first = true      ran
probe_last  = nil       never ran
```

The error stopped the chunk at that line. Everything above it took effect; everything
below it did not. Neovim is still running, and nothing continues to remind you.

That is the whole justification for lesson 00's marker. `vim.g.hero_config_loaded` is on
the **last** line precisely so that `:= vim.g.hero_config_loaded` distinguishes "ran to
completion" from "ran until it broke". And `:messages` is where the error you missed at
startup is still recorded.

## Guarding a `require` — and when not to

The idiom you will see everywhere:

```lua
local ok, mod = pcall(require, 'some.module')
if not ok then
  return
end
```

Measured: `pcall(require, 'definitely_not_installed')` gives `ok=false` and execution
continues past it.

**The wrong reading to reject.** Having learned this, the tempting move is to wrap *every*
`require` in your config, so nothing can ever break startup. That produces a config that
fails silently, which is strictly worse than one that fails loudly: a typo in a module name
now produces a config missing a third of its keymaps, with no error, and you find out days
later when you reach for one.

The discriminating question is **"is this optional?"**

- **Required** — your own modules, the plugin manager. If `hero.options` is missing,
  something is badly wrong and you want to know immediately. Do **not** guard it.
- **Optional** — a plugin you may not have installed on this machine, a work-only module,
  anything behind a condition. Guard it, **and say something**.

"Say something" is the part people skip. A guard that returns silently is indistinguishable
from a guard that never fired:

```lua
local ok, mod = pcall(require, 'work.secrets')
if not ok then
  vim.notify('work.secrets not available, skipping', vim.log.levels.DEBUG)
  return
end
```

`vim.notify` takes a level from `vim.log.levels`, measured here as:

```
{ TRACE = 0, DEBUG = 1, INFO = 2, WARN = 3, ERROR = 4, OFF = 5 }
```

`DEBUG` for "expected and uninteresting", `WARN` for "you probably want to fix this".

### The bare-`pcall` mistake

```lua
if not pcall(require, 'x') then
  return
end
```

Measured: this **discards the error message entirely**. You know it failed and nothing
about why — and "module not found" and "the module threw on line 4" need completely
different responses. Keep the second return value:

```lua
local ok, err = pcall(require, 'x')
if not ok then
  vim.notify(('x failed: %s'):format(err), vim.log.levels.WARN)
  return
end
```

## Worked example

`config/17` adds a helper and uses it for exactly one optional thing.

```lua
-- lua/hero/util.lua
local M = {}

--- Require a module that may legitimately be absent.
--- Returns the module, or nil after reporting why.
function M.optional(name)
  local ok, mod = pcall(require, name)
  if ok then
    return mod
  end
  vim.notify(('hero: optional module %s unavailable: %s'):format(name, mod), vim.log.levels.DEBUG)
  return nil
end

return M
```

Three decisions in that, all from this lesson.

**It keeps the error** and puts it in the message, because "not found" and "threw while
loading" need different fixes.

**It reports at `DEBUG`**, because an absent optional module is expected. A `WARN` here
would train you to ignore warnings.

**It returns `nil`, not `false`**, so the caller can write `local m = util.optional(…)` and
test it the way they test anything else.

And in `hero/init.lua`:

```lua
require('hero.options')   -- required: let it fail loudly
require('hero.keymaps')   -- required: let it fail loudly
```

Both unguarded, deliberately. The helper exists for the module you will add in a later
phase that is genuinely optional — and the comment in the snapshot says so, because the
next person to read it will otherwise wrap these two in it.

**The wrong reading to reject.** A tidier-looking arrangement is to guard the two requires
and notify on failure, on the grounds that it is defensive and costs nothing. It costs
something specific: `hero.options` sets `mapleader`, and `hero.keymaps` depends on it
(lesson 04). If `options` fails and the config continues, every mapping silently binds to
the wrong leader — the exact failure lesson 04 spent a section on, now reached by a
different route and harder to diagnose because a notification scrolled past. A failure that
makes everything after it wrong should stop the chunk.

## Distinctions worth keeping straight

| These look alike | but |
|---|---|
| `pcall` / `xpcall` | loses the traceback / a handler runs while the stack exists |
| `pcall` catching / a function returning `nil` | it raised / it did not raise at all |
| `error('m')` / `error('m', 0)` | position prepended / bare message |
| `error(msg, 1)` / `error(msg, 2)` | blames your line / blames the caller's |
| `error('m')` / `error({…})` | a string / a table, passed through unchanged |
| `assert(c)` / `assert(c, 'm')` | "assertion failed!" / your message |
| `assert(0)` / `assert(false)` | **passes** — 0 is truthy / raises |
| `if not pcall(f)` / `local ok, err = pcall(f)` | discards the reason / keeps it |
| a required module / an optional one | let it fail loudly / guard it **and report** |
| a silent guard / a notified guard | indistinguishable from never firing / diagnosable |
| "Neovim started" / "my config ran" | it always starts / the marker on the last line |
| `vim.log.levels.DEBUG` / `WARN` | expected and uninteresting / you should fix this |

## Common errors

### Your config applied some settings and not others

An error stopped the chunk part way. `:= vim.g.hero_config_loaded` to confirm, then
`:messages` for the error that scrolled past at startup.

### `pcall` returned `ok = true` for something that plainly did not work

The function signalled failure by returning `nil` rather than raising. `pcall` only reports
whether something raised.

### You know a guarded call failed but not why

You wrote `if not pcall(f)` and threw the message away. Capture the second return value.

### A guard fires and you never notice

It returns silently. Add a `vim.notify` with a level, or you cannot distinguish "skipped"
from "never reached".

### `pcall` gave you one line and you need the call stack

`pcall` discards it. Use `xpcall(f, debug.traceback)`.

### An error message has a confusing file and line

`error` prepends the position of the line that *called* it. If that is your helper rather
than the caller's mistake, pass level `2`.

### `assert` passed on a value you expected to fail

`0` and the empty string are truthy in Lua. Only `nil` and `false` are falsy. Compare
explicitly.

### Everything in your config is wrapped in `pcall` and nothing works

A typo in a module name now removes a third of your config silently. Guard only what is
genuinely optional.

## Check yourself

1. What are the two values `pcall` returns, in each outcome?
2. Does `pcall` catch a function that returns `nil` to signal failure?
3. What does the `0` do in `error('msg', 0)`, and when do you want it?
4. What does level `2` do, and in what kind of function is it right?
5. Give two things `assert` does beyond raising.
6. Why does `assert(0)` pass?
7. What does `pcall` lose, and what recovers it?
8. A file errors on line 3 of 10. What is true of lines 1–2 and 4–10, and of Neovim?
9. Which `require` calls in a config should *not* be guarded, and why?
10. What is wrong with `if not pcall(require, 'x') then return end`?

<details><summary>Answers</summary>

1. On success, `true` and the function's return values. On failure, `false` and the error
   value.
2. No. Returning `nil` is not raising, so `ok` is `true` and the `nil` comes back as the
   result.
3. It suppresses the position information that `error` would otherwise prepend. Use it
   when the message is for a user, where a file and line is noise.
4. It blames the **caller's** line rather than the line that called `error`. Right in a
   validation helper, where the useful location is where the bad argument came from.
5. It returns its value on success, so `local x = assert(f())` checks and binds in one
   step; and it takes a message as its second argument.
6. Only `nil` and `false` are falsy in Lua. `0` is truthy.
7. The traceback. `xpcall(f, debug.traceback)` runs the handler while the stack still
   exists.
8. Lines 1–2 took effect, lines 4–10 did not, and Neovim is still running with no ongoing
   indication. The marker on the last line and `:messages` are how you find out.
9. Your own modules and the plugin manager — anything whose absence means something is
   badly wrong, and anything later code depends on. Guarding them converts a loud failure
   into a silently wrong config.
10. It discards the error message, and "not found" versus "threw while loading" need
    different responses.

</details>

## Key takeaways

- `pcall` returns a verdict plus either the result or the error. It catches raises, not
  functions that return `nil`.
- `error` prepends position unless you pass `0`, and its level argument chooses whose line
  is blamed — `2` in a validation helper.
- `assert` returns its value on success, and `assert(0)` passes because only `nil` and
  `false` are falsy.
- `pcall` discards the traceback; `xpcall(f, debug.traceback)` keeps it.
- An error stops the chunk, not Neovim. That is why the completion marker is on the last
  line and why `:messages` matters.
- Guard the **optional**, let the **required** fail loudly, and always report a guard that
  fired — a silent guard cannot be distinguished from one that never ran.
- Never write `if not pcall(f)`. Keep the error.

## Lookup (not the lesson)

| Tag | For |
|---|---|
| `:h luaref-pcall` | and `:h luaref-xpcall` |
| `:h luaref-error` | the level argument, and non-string errors |
| `:h luaref-assert` | what it returns |
| `:h debug.traceback()` | the handler to pass `xpcall` |
| `:h lua-error` | how a Lua error becomes a Vim error message |
| `:h E5108` | the runtime-error code from lesson 13's grid |
| `:h vim.notify()` | reporting, and `:h vim.log.levels` for the levels |
| `:h :messages` | the transcript of what scrolled past |
| `:h vim.F.npcall()` | a `pcall` that returns `nil` instead of a boolean pair |
| `:h vim.health` | and `:h :checkhealth` — the structured version of all this |

Now go to [`TASK.md`](TASK.md).
