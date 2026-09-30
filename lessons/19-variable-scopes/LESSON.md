# 19 — Variables: `vim.g`, `vim.b`, `vim.w`, `vim.t`, `vim.v`, `vim.env`

Lesson 18 was about options — settings Neovim defines. This is about **variables**, which
you define, and which are the standard way a config shares state with itself and with
plugins. The structure mirrors options: one table per scope. And there is one trap here
that is worse than anything in lesson 18, because it fails **silently and completely**.

## What this lesson asks of you

Store state where the right things can see it, and recognise the reason
`vim.g.config.field = value` appears to work and does nothing at all.

No config work. Nothing is added to `~/.config/hero`.

## Six tables, mirroring Vimscript's prefixes

| Lua | Vimscript | Scope |
|---|---|---|
| `vim.g` | `g:` | global |
| `vim.b` | `b:` | buffer-local |
| `vim.w` | `w:` | window-local |
| `vim.t` | `t:` | tabpage-local |
| `vim.v` | `v:` | Vim's own predefined variables |
| `vim.env` | `$NAME` | environment |

These are not parallel systems — they are **the same storage**. Measured, both directions:

```
vim.g.probe = 'from lua'   then  :echo g:probe    ->  "from lua"
:let g:probe2 = 'from vimscript'  then  vim.g.probe2  ->  "from vimscript"
```

That is why `vim.g` is how you configure a Vimscript plugin from Lua: a plugin reading
`g:plugin_option` sees what you wrote to `vim.g.plugin_option`.

`vim.b`, `vim.w` and `vim.t` take an optional index, and without one they mean *current*:

```
vim.b.here     -- current buffer
vim.b[bufnr]   -- that buffer
vim.w[winid]   -- that window
vim.t[tabnr]   -- that tab page
```

Measured — buffer variables really are per buffer, and tab variables per tab:

```
vim.b[b1].note = 'one'   vim.b[b2].note = 'two'      independent
vim.t.marker = 'tab1'; :tabnew  ->  vim.t.marker is nil
                       :tabprevious  ->  "tab1" again
```

### Deleting a variable

Assign `nil`:

```
vim.g.gone = 'here'   ->  exists('g:gone') is 1
vim.g.gone = nil      ->  exists('g:gone') is 0
```

That is `:unlet`. Setting a variable to `nil` and deleting it are the same operation here,
which differs from a Lua table where you might care about the distinction.

## The trap: stored tables do not round-trip by reference

This is the important part of the lesson.

```lua
vim.g.cfg = { a = 1, list = { 1, 2 } }
vim.g.cfg.a = 42                         -- looks fine
```

Measured:

```
initial                                 { a = 1, list = { 1, 2 } }
after vim.g.cfg.a = 42               -> { a = 1, list = { 1, 2 } }     unchanged, NO error
after table.insert(vim.g.cfg.list, 3) -> { a = 1, list = { 1, 2 } }    also unchanged
```

No error. No effect. The assignment is simply lost.

The reason is that **every read of `vim.g.cfg` constructs a new Lua table** from the stored
value. Measured:

```
local r1, r2 = vim.g.cfg, vim.g.cfg
r1 ~= r2   ->  true      two reads, two different tables
```

So `vim.g.cfg.a = 42` reads the variable — producing a fresh temporary table — sets a field
on that temporary, and then discards it. Nothing was ever written back.

This is the reference rule from lesson 14 turned inside out. There, assignment shared a
reference and you had to use `vim.deepcopy` to get independence. Here you get a copy
whether you want one or not, and the mutation you expected to propagate does not.

### The correct pattern: read, modify, write back

```lua
local cfg = vim.g.cfg
cfg.a = 42
vim.g.cfg = cfg
```

Measured: `{ a = 42, list = { 1, 2 } }`. Three lines, and the third is the one people omit.

**The wrong reading to reject.** The natural response on discovering this is to assume
`vim.g` cannot hold tables usefully, and to flatten everything into
`vim.g.cfg_a`, `vim.g.cfg_list`. It can hold tables perfectly well — you just cannot
*mutate through it*. The rule to carry is narrower and more useful than "avoid tables in
`vim.g`": **`vim.g` is storage, not a live object.** Read it out, work on the copy, put it
back. That is the same discipline you would use for a value in a database, and thinking of
it that way makes the behaviour unsurprising rather than a special case to memorise.

## Type conversion across the boundary

A value stored in `vim.g` goes through Vimscript's type system. Mostly this is invisible;
booleans are the visible case. Measured:

```
vim.g.flag = true    then  :echo g:flag   ->  "v:true"
                     then  vim.g.flag     ->  boolean true
```

So a Lua `true` becomes `v:true` on the Vimscript side and comes back as a Lua boolean.
That round-trips, but a Vimscript plugin reading `g:flag` sees `v:true`, not `1` — which
matters for older plugins that test `if g:flag == 1`.

## `vim.v`: Vim's own variables

`vim.v` exposes `v:` — variables Neovim maintains. Measured:

```
v:count        = 0        the count typed before a mapping
v:count1       = 1        the same, but 1 when no count was given
v:shell_error  = 0        exit status of the last shell command
v:errmsg       = ""       the last error message
v:progname     = "nvim"
v:servername   = "/run/user/1000//nvim.1266779.0"
```

Most are **read-only**:

```
vim.v.count = 5    ->  Key is read-only: count
vim.v.errmsg = 'x' ->  allowed        (v:errmsg is writable)
```

Two of these you will use. **`v:count` / `v:count1`** is how a mapping reads the count you
typed in front of it — the mechanism behind `3<leader>d` doing something three times, which
lesson 23 puts to work. And **`v:shell_error`** is how you check whether an external command
succeeded, which lesson 26 replaces with something better.

`v:count1` exists because `v:count` is `0` when no count was given, and `0` is a useless
multiplier. Use `v:count1` when you want "the count, or 1".

## `vim.env`

The process environment, and it is live:

```
vim.env.HOME            ->  "/home/n8"
vim.env.HERO_PROBE = 'set-from-lua'
  then vim.fn.getenv('HERO_PROBE')  ->  "set-from-lua"
  then :echo $HERO_PROBE            ->  "set-from-lua"
```

Writing it affects child processes — anything you run with `vim.system` (lesson 26) or a
`:terminal`. That is how you set a variable for a language server or a build command without
changing your shell.

## Choosing a scope

The question is the same shape as lesson 18's: **who needs to see this, and how long should
it live?**

| Need | Scope |
|---|---|
| Configure a plugin | `vim.g` — plugins look in `g:` |
| A setting for one file's buffer | `vim.b` |
| State for one window's view | `vim.w` |
| State for a layout | `vim.t` |
| Something a child process needs | `vim.env` |
| State only your Lua uses | **a module-level `local`** (lesson 16) |

That last row matters. `vim.g` is not the Lua answer to "I need a variable" — a `local` in a
module is, and it is better: it cannot collide with a plugin, it does not go through type
conversion, and it can hold a live table you *can* mutate. Reach for `vim.g` when something
outside your Lua needs to see it.

## Worked example

A toggle that remembers its state, done three ways, with the right answer last.

**Attempt one — mutate a stored table.** Broken, silently:

```lua
vim.g.hero_state = { wrap = false }

local function toggle()
  vim.g.hero_state.wrap = not vim.g.hero_state.wrap   -- does nothing
  vim.wo.wrap = vim.g.hero_state.wrap
end
```

Every call reads `false`, writes to a temporary, and sets `wrap` to `true` forever.

**Attempt two — read, modify, write back.** Correct, and unnecessarily public:

```lua
local function toggle()
  local state = vim.g.hero_state
  state.wrap = not state.wrap
  vim.g.hero_state = state
  vim.wo.wrap = state.wrap
end
```

**Attempt three — a closure over a local.** This is lesson 15's counter, and it is the right
answer here:

```lua
local function make_toggle()
  local wrapping = false
  return function()
    wrapping = not wrapping
    vim.wo.wrap = wrapping
  end
end
```

No variable table involved, no copy semantics to remember, and nothing outside this module
can see or break it.

**The wrong reading to reject.** Having learned six new tables, the pull is to use them —
and `vim.g` in particular feels like "the proper place for config state". For state that
only your own Lua reads, it is strictly worse than a `local`: you gain a namespace collision
risk and the copy-on-read trap, and you gain nothing, because nothing else is looking. Use
`vim.g` when the audience is a plugin, a Vimscript function, or a future `:echo` while
debugging. Otherwise the answer is the thing lesson 15 already taught you.

## Distinctions worth keeping straight

| These look alike | but |
|---|---|
| `vim.g` / `g:` | the same storage, two spellings |
| `vim.b` / `vim.b[n]` | current buffer / that buffer |
| `vim.g.t.field = v` / read-modify-write | **silently lost** / the working pattern |
| two reads of `vim.g.t` | two **different** tables |
| lesson 14's reference rule / this one | assignment shares / `vim.g` copies on every read |
| `vim.g.x = nil` / `:unlet g:x` | the same operation |
| `v:count` / `v:count1` | `0` when no count / `1` when no count |
| `vim.v` reads / writes | mostly read-only; `v:errmsg` is one you may write |
| Lua `true` in `vim.g` / in Vimscript | `true` / `v:true`, not `1` |
| `vim.env` / `os.getenv` | live and writable, affects children / a snapshot |
| `vim.g` for your own state / a module `local` | collides and copies / private and live |

## Common errors

### `vim.g.config.option = value` did nothing, and did not error

Every read of `vim.g.config` builds a new table. You set a field on a temporary that was
then discarded. Read it into a local, modify, assign back.

### `table.insert(vim.g.list, x)` did nothing

Same cause. `vim.g` is storage, not a live object.

### Two reads of the same `vim.g` table are not `==`

Correct, and the reason for the above. Each read constructs a fresh table.

### A Vimscript plugin testing `if g:flag == 1` does not see your `true`

A Lua `true` arrives as `v:true`. Store `1` if the plugin wants a number.

### `Key is read-only: count`

Most `v:` variables are maintained by Neovim. You can read `v:count`; you cannot set it.

### Your mapping's count is always 0

`v:count` is `0` when no count was typed. Use `v:count1` if you want a usable multiplier.

### A buffer variable you set is gone

You set it on a different buffer — `vim.b` with no index means *current*, and the current
buffer may have changed. Index it explicitly: `vim.b[bufnr].name`.

### An environment variable you set is not visible to a language server

It probably started before you set it. `vim.env` affects processes launched afterwards.

## Check yourself

1. Give the Vimscript prefix for each of `vim.g`, `vim.b`, `vim.w`, `vim.t`.
2. Are `vim.g.x` and `g:x` two names for one thing, or two stores?
3. What does `vim.b.name` mean when you have not indexed it?
4. `vim.g.cfg.a = 42` — what happens, and why is there no error?
5. Prove the cause in one line of code.
6. Write the three-line pattern that does work.
7. Difference between `v:count` and `v:count1`, and when do you want the second?
8. Can you write `v:count`? Name a `v:` variable you *can* write.
9. A Vimscript plugin checks `g:flag == 1`. You set `vim.g.flag = true`. What does it see?
10. You need state that only your own Lua modules read. Where does it go, and why not
    `vim.g`?

<details><summary>Answers</summary>

1. `g:`, `b:`, `w:`, `t:`.
2. One thing. They are the same storage, verified in both directions.
3. The variable on the **current** buffer. `vim.b[bufnr].name` names a specific one.
4. Nothing. Reading `vim.g.cfg` builds a fresh Lua table, the field is set on that
   temporary, and the temporary is discarded. No error because every step was individually
   legal.
5. `local a, b = vim.g.cfg, vim.g.cfg; print(a ~= b)` — it prints `true`, so each read is a
   different table.
6. `local cfg = vim.g.cfg` / `cfg.a = 42` / `vim.g.cfg = cfg`.
7. `v:count` is `0` when no count was typed; `v:count1` is `1`. Use `v:count1` whenever the
   value is a multiplier, since `0` would be useless.
8. No — `Key is read-only: count`. `v:errmsg` is writable.
9. `v:true`, not `1`. Store `1` if the plugin wants a number.
10. A module-level `local` (lesson 16). It cannot collide with a plugin, it holds a live
    table you can mutate, and nothing outside needs to see it — so `vim.g` would add the
    copy-on-read trap and a collision risk for no benefit.

</details>

## Key takeaways

- Six tables, one per scope, and they are the **same storage** as Vimscript's `g:`, `b:`,
  `w:`, `t:`, `v:` and `$NAME`. That is how you configure a Vimscript plugin from Lua.
- `vim.b`, `vim.w` and `vim.t` mean *current* without an index, and take one to be explicit.
- **A table in `vim.g` does not round-trip by reference.** Every read builds a new table, so
  `vim.g.t.field = v` is silently lost. Read, modify, write back.
- Treat `vim.g` as storage rather than a live object, and the behaviour stops being a
  special case.
- Assigning `nil` deletes, which is `:unlet`.
- `v:count1` is the count you actually want in a mapping. Most `v:` variables are read-only.
- For state only your Lua reads, a module `local` beats `vim.g` on every axis.

## Lookup (not the lesson)

| Tag | For |
|---|---|
| `:h lua-vim-variables` | the whole family, and the conversion rules |
| `:h vim.g` | and `:h vim.b`, `:h vim.w`, `:h vim.t` |
| `:h vim.v` | and `:h vim.env` |
| `:h internal-variables` | the Vimscript side, and `:h g:`, `:h b:`, `:h w:`, `:h t:` |
| `:h vim-variable` | every `v:` variable, with which are writable |
| `:h v:count` | and `:h v:count1` — the mapping-count pair |
| `:h v:shell_error` | checking an external command, superseded in lesson 26 |
| `:h v:true` | what a Lua boolean becomes |
| `:h :unlet` | the Ex equivalent of assigning `nil` |
| `:h exists()` | testing for a variable, and `:h getenv()` |
| `:h lua-special-tbl` | the conversion corner cases, if you hit one |

Now go to [`TASK.md`](TASK.md).
