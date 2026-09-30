# 16 — Modules, `require`, and the runtimepath

Lesson 15 ended with a rule that makes a single-file config awkward: a `local` is
invisible outside its chunk. Modules are how files share anything, and `require` is how
they find each other. Two facts about `require` do most of the work — it searches the
**runtimepath**, not `package.path`, and it **caches**, which is why your config stops
responding to `:source` once it has modules in it.

## What this lesson asks of you

Split `~/.config/hero/init.lua` into modules that find each other, and explain why
re-sourcing the config no longer picks up a change.

This lesson changes `~/.config/hero`. The reference snapshot is `config/16`.

## The module pattern

A module is a file that **returns** something. By convention a table:

```lua
-- lua/hero/util.lua
local M = {}

function M.greet(name)
  return 'hello ' .. name
end

return M
```

and the caller gets exactly what the file returned:

```lua
local util = require('hero.util')
util.greet('world')
```

That is the whole pattern. `M` is a local, so nothing leaks (lesson 15), and the single
`return M` at the bottom is the file's entire public surface.

## How `require` finds a file

`require('a.b.c')` converts the dots to directory separators and looks for
`lua/a/b/c.lua` — **inside every `lua/` directory on the runtimepath** (lesson 00).

Measured against a fixture prepended to the runtimepath:

```
require('flat')           ->  lua/flat.lua
require('pkg')            ->  lua/pkg/init.lua          a directory works, via init.lua
require('hero.sub.deep')  ->  lua/hero/sub/deep.lua     dots are separators
```

Three rules from that:

- **`lua/x.lua` and `lua/x/init.lua` are both `require('x')`.** Use the directory form
  when a module will grow into several files.
- **Dots are not namespaces**, they are path separators. `require('hero.util')` is a file
  at `lua/hero/util.lua` and nothing more.
- **A leading `lua/` never appears in the name.** `require('lua.hero.util')` is wrong and
  is the commonest first mistake.

### First match on the runtimepath wins

Measured, with two fixture directories both providing `lua/shared.lua`:

```
rtp order: …/rtp1, …/rtp2
require('shared').from  ->  rtp1        the earlier entry won
require('only2').from   ->  rtp2-only   later entries are still searched
```

So the runtimepath is a search path in the ordinary sense: earlier wins for a name that
exists twice, and later entries still provide names that are unique to them. Lesson 00's
palindrome — your config first, your `after/` last — is what decides who wins.

### `require` does not use `package.path`

This surprises people, and the error message actively misleads. A missing module reports:

```
module 'no_such_module_anywhere' not found:
	no field package.preload['no_such_module_anywhere']
	no file './no_such_module_anywhere.lua'
	no file '/usr/share/luajit-2.1/no_such_module_anywhere.lua'
	no file '/usr/local/share/lua/5.1/no_such_module_anywhere.lua'
	…
```

Every path in that list comes from `package.path` and `package.cpath`. Measured: the
number of `package.path` entries mentioning the fixture directories on the runtimepath is
**zero** — Neovim adds its own loader that searches the runtimepath, and that loader does
not contribute to the error text.

**The wrong reading to reject.** The natural response to that error is to start editing
`package.path`, because the message is a list of paths that were searched and yours is not
in it. That is the wrong fix: your module is found through the runtimepath, so the
question is whether your file is under a `lua/` directory on it. Check with

```vim
:= vim.api.nvim_get_runtime_file('lua/hero/util.lua', true)
```

An empty list means the file is not where you think it is. The error's path list is
genuinely not the place Neovim looked for your config module.

## `require` caches, and this breaks your reload loop

The second load-bearing fact. Measured:

```
two requires  ->  the file ran 1 time; both calls returned the SAME table
```

`require` runs a file **once per session** and remembers the result in `package.loaded`.
Every later `require` of that name hands back the same value without touching the disk.

That is why lesson 04's warning came due. `:source ~/.config/hero/init.lua` re-runs
`init.lua` — but every `require` inside it is now a cache hit, so none of your module
files are re-read. The config appears not to respond to your edits.

### Forcing a reload

Clear the cache entry, then require again. Measured:

```
package.loaded['counted'] = nil
require('counted')  ->  the file ran a 2nd time; a DIFFERENT table came back
```

Note *different table*. Anything that captured the old table still holds the old one —
a keymap bound to `old_module.fn` keeps calling the old function. That is why a reload
helper is convenient and a restart is authoritative.

`dofile` does not cache at all:

```
two dofile calls  ->  the file ran 2 times
```

so `dofile` is occasionally the right tool for a script you want re-run, and the wrong
tool for a module, because every caller would get its own copy.

### `vim.loader`

Neovim ships a module cache that stores compiled bytecode, enabled with
`vim.loader.enable()` (both `vim.loader.enable` and `vim.loader.reset` are present here —
measured). It speeds startup and adds a second layer to invalidate when you are
debugging; `vim.loader.reset()` clears it. Know it exists so that "my change is not
taking effect" has a second suspect.

## Structuring a config

With `require` understood, the layout follows. `config/16` splits the single file into:

```
~/.config/hero/
├── init.lua                  the entry point: a few require calls
└── lua/
    └── hero/
        ├── init.lua          requires the pieces, in order
        ├── options.lua
        └── keymaps.lua
```

and `init.lua` becomes one line plus the completion marker:

```lua
require('hero')
```

Two design points, both from earlier lessons.

**Order is load-bearing, and now it is explicit.** `hero/init.lua` requires `options`
before `keymaps`, because `mapleader` must be set before any mapping is created (lesson
04). In one file that was a line ordering; across modules it is a `require` ordering, and
it is the reason `hero/init.lua` exists at all rather than `init.lua` requiring the two
directly — one file names the order.

**The namespace is yours.** `hero/` exists so that `require('options')` — which could
collide with any plugin shipping `lua/options.lua` — becomes `require('hero.options')`,
which cannot. Your real config uses `MayTheSForceBeWithYou/` for the same reason.

## Worked example

Adding a third module, and the two mistakes that eat the time.

You want `lua/hero/util.lua` with a helper, used from `keymaps.lua`.

```lua
-- lua/hero/util.lua
local M = {}

function M.repo_root()
  return vim.fs.root(0, '.git')
end

return M
```

```lua
-- lua/hero/keymaps.lua
local util = require('hero.util')
```

**Mistake one: forgetting `return M`.** The file runs, `require` succeeds, and you get
`true` — because a module that returns nothing is recorded as loaded with the value
`true`. The symptom is `attempt to index a boolean value`, which by lesson 13's rule is
*not* a name problem: the name resolved fine, to a boolean. Look for the missing return.

**Mistake two: requiring it as `lua.hero.util`.** The `lua/` directory is where the
search starts, so it is never part of the name.

**The wrong reading to reject.** After adding the module, you `:source %` and your new
keymap does not appear — so you conclude the module is not being found, and start checking
paths. It is being found; `keymaps.lua` is simply not being re-read, because
`require('hero.keymaps')` was cached the first time. Nothing about the path is wrong. The
distinction to make before debugging is *"is this not found, or not re-run?"* — and the
test is a real restart. If a restart shows your change, the path was always fine and you
were fighting the cache.

## Distinctions worth keeping straight

| These look alike | but |
|---|---|
| `lua/x.lua` / `lua/x/init.lua` | both are `require('x')` |
| `require('hero.util')` / `require('lua.hero.util')` | correct / `lua/` is where the search starts |
| dots as namespaces / as separators | they are path separators |
| `require` searching `package.path` / the runtimepath | it uses Neovim's **runtimepath** loader |
| the not-found error's path list / where it looked for your module | `package.path` / the runtimepath, which the error omits |
| `require` / `dofile` | caches, once per session / re-runs every time |
| a reload / a restart | new table, old references survive / authoritative |
| "not found" / "not re-run" | a path problem / the cache — different fixes |
| `return M` present / absent | your table / `true`, and `index a boolean value` |
| earlier rtp entry / later | wins for a duplicate name; later still provides unique ones |
| `vim.loader` cache / `package.loaded` | compiled bytecode / the in-session module table |

## Common errors

### `module 'hero.util' not found:` followed by a list of paths

Your file is not under a `lua/` directory on the runtimepath. Do not edit
`package.path` — the listed paths are not where Neovim looked for it. Check with
`:= vim.api.nvim_get_runtime_file('lua/hero/util.lua', true)`.

### `attempt to index a boolean value`

The module has no `return M`. A module that returns nothing is cached as `true`.

### `module 'lua.hero.util' not found`

Drop the `lua.` — the `lua/` directory is where the search begins.

### Your edit to a module has no effect after `:source %`

`require` is cached. Restart, or clear `package.loaded['hero.util']` and require again.
This is the reload-loop limit lesson 04 warned about.

### You reloaded a module and half your config still uses the old one

A reload produces a **different table**, and anything that captured the old one — a
keymap callback, an autocommand — still holds it. Restart when correctness matters.

### Two plugins fight over the same module name

Both ship `lua/x.lua` and the earlier runtimepath entry wins. Namespace your own modules
under a directory nobody else will use.

### A module's top-level code ran twice

You have both `require`d it and `dofile`d or `:source`d it, or you cleared
`package.loaded` and required it again. Top-level side effects in a module are worth
avoiding for exactly this reason.

## Check yourself

1. What does a module have to do to be usable by `require`?
2. Give the two file layouts that both answer to `require('hero')`.
3. Where does `require` search, and what is conspicuously *not* searched?
4. `module 'x' not found` lists a dozen paths. Are those the paths your config module
   would be found in?
5. How many times does a required file run per session, and where is the result kept?
6. You edited a module and `:source`d your init. Why did nothing change?
7. You cleared `package.loaded['m']` and required it again. What is true of the new value
   relative to the old one, and what problem does that create?
8. Why does `config/16` have `lua/hero/init.lua` rather than `init.lua` requiring the two
   modules directly?
9. Why is the `hero/` directory there at all?
10. `attempt to index a boolean value` on a fresh module. What is missing?

<details><summary>Answers</summary>

1. Return something — by convention a table. The value `require` gives the caller is
   whatever the file returned.
2. `lua/hero.lua`, or `lua/hero/init.lua`.
3. Every `lua/` directory on the runtimepath, in order. `package.path` is **not** used by
   Neovim's loader for these.
4. No. They come from `package.path` and `package.cpath`. Measured, none of the
   runtimepath fixture directories appeared there, so the error's list omits where Neovim
   actually looked.
5. Once. The result is stored in `package.loaded` under the module name and every later
   `require` returns it without touching the disk.
6. `init.lua` re-ran, but every `require` inside it was a cache hit, so no module file was
   re-read.
7. It is a **different table**. Anything that captured the old one — a keymap callback, an
   autocommand — still holds the old functions, so the config ends up half reloaded.
8. Because load order is load-bearing: `options` must run before `keymaps` so that
   `mapleader` exists before any mapping is created. One file naming that order is the
   point of `hero/init.lua`.
9. Namespacing. `require('options')` could collide with any plugin shipping
   `lua/options.lua`; `require('hero.options')` cannot.
10. `return M` at the end of the file. A module that returns nothing is cached as `true`.

</details>

## Key takeaways

- A module returns a value, conventionally a table built from a `local M`. That return is
  its entire public surface.
- `require('a.b')` looks for `lua/a/b.lua` in every `lua/` directory on the runtimepath,
  earlier entries winning. `lua/x/init.lua` is equivalent to `lua/x.lua`.
- `require` does **not** use `package.path`, and the not-found error's path list is
  therefore misleading. Check with `nvim_get_runtime_file` instead of editing
  `package.path`.
- `require` caches in `package.loaded`: once per session. This is why `:source` stops
  working as a reload loop once your config has modules.
- A reload yields a *different* table, so captured references go stale. A restart is the
  authoritative answer.
- Before debugging a path, decide whether the problem is "not found" or "not re-run" —
  a restart distinguishes them in one step.
- Namespace your modules under a directory of your own, and let one file name the load
  order.

## Lookup (not the lesson)

| Tag | For |
|---|---|
| `:h lua-require` | how Neovim resolves a module name |
| `:h lua-module-load` | the loader and the `lua/` convention |
| `:h 'runtimepath'` | the search path itself |
| `:h lua-package-path` | and `:h package.path` — what Lua's own mechanism does |
| `:h vim.loader` | the bytecode cache, with `:h vim.loader.enable()` and `:h vim.loader.reset()` |
| `:h luaref-require` | Lua's own semantics, including `package.loaded` |
| `:h luaref-dofile` | the uncached alternative |
| `:h vim.api.nvim_get_runtime_file()` | asking where a runtime file actually is |
| `:h after-directory` | why `after/` wins, from lesson 00's palindrome |
| `:h :scriptnames` | every file sourced this session, in order |

Now go to [`TASK.md`](TASK.md).
