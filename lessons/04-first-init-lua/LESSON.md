# 04 — Your first `init.lua`: options and one keymap

Lesson 00 created an `init.lua` that set one variable and proved it ran. This
lesson puts real settings in it and binds your first key. Two things here are
load-bearing far beyond their apparent size: the order in which the file does
things, and the loop you use to check that a change took effect. Both are where
configs go wrong in ways that produce no error message at all.

## What this lesson asks of you

Write a config that sets options and one keymap, and be able to prove — from
inside Neovim, without restarting — which file set a given option and what a given
key is actually bound to.

This lesson changes `~/.config/hero`. The reference snapshot is `config/04`.

## Setting an option from Lua

```lua
vim.opt.number = true
vim.opt.shiftwidth = 2
vim.opt.ignorecase = true
```

Each line is the Lua equivalent of an Ex `:set` command — `:set number`,
`:set shiftwidth=2`, `:set ignorecase`. Booleans are real Lua booleans, numbers are
numbers, and strings are strings.

There is a second spelling, `vim.o.number = true`, and a whole family of
scope-specific tables (`vim.bo`, `vim.wo`, `vim.go`). They differ in ways that
matter, and **lesson 18 is entirely about that difference** — including why
`vim.opt` hands you back an object rather than a value, which is the single most
confusing thing about it. For now: use `vim.opt` to *set*, and be aware that
reading it back is not as simple as it looks.

The options in `config/04` and why each is there:

| Option | Effect | Why in a starter config |
|---|---|---|
| `number` | line numbers in the gutter | you will be told line numbers by errors |
| `expandtab` | `<Tab>` inserts spaces | lesson 01 drill 15 met the default: a real tab |
| `shiftwidth` | how far `>>` shifts | 2 matches the Lua in this repo |
| `tabstop` | how wide a tab *displays* | keep equal to `shiftwidth` until you know why not |
| `ignorecase` | searches ignore case | almost always wanted |
| `smartcase` | …unless you type a capital | the half that makes `ignorecase` usable |

`ignorecase` and `smartcase` are a pair and neither is much good alone. With both
on, `/error` finds `Error` and `ERROR`, while `/Error` finds only `Error`. Setting
`ignorecase` without `smartcase` removes your ability to search case-sensitively
at all, which people discover a week later and blame on something else.

## Order matters, and the first thing it matters for is the leader

`<leader>` is a placeholder for a key of your choosing, so that your personal
mappings live in their own namespace instead of stealing built-in keys. Space is
the usual choice because it does nothing useful in Normal mode.

```lua
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
```

Now the part that costs people an evening. **`<leader>` is expanded when the
keymap is created, not when you press it.** The mapping does not store "leader
then n"; it stores the actual key. Measured — two mappings created either side of
a change to `mapleader`, then read back:

```
lhs=",a" desc=set with comma leader
lhs=";b" desc=set with semicolon leader
```

Both exist, on different prefixes, from identical `<leader>` source text.

The consequence is a rule: **set `mapleader` before anything that defines a
mapping.** In a one-file config that just means putting it near the top. It
becomes a real constraint in lesson 27, when the config splits into modules, and
in lesson 28, when a plugin manager arrives and plugin specs can declare their own
keys — a plugin loaded before your `mapleader` line binds its keys to the default
leader, which is `\`.

**The wrong reading to reject.** Because nothing errors, the natural conclusion
when `<leader>n` does nothing is that the *keymap* is wrong, and people rewrite it
several ways. The keymap is fine. It is bound to `\n` because `mapleader` was
still unset when the line ran. The way to see this in one step is `:nmap <leader>n`,
which prints the mapping with the leader already expanded — if the listing shows
`\n` when you expected `<Space>n`, you have found it.

`maplocalleader` is the same idea for mappings that are meant to be
buffer-specific. Set it at the same time even if nothing uses it yet; plugins do.

## Your first keymap

```lua
vim.keymap.set('n', '<leader>n', ':nohlsearch<CR>', { desc = 'Clear search highlight' })
```

Four arguments:

1. **mode** — `'n'` for Normal. Can be a list: `{ 'n', 'v' }`.
2. **lhs** — the keys you press. `<leader>`, `<C-x>`, `<Esc>` notation works.
3. **rhs** — what happens. A string here, meaning "type these keys". The `<CR>`
   matters: without it you get a `:nohlsearch` sitting on the command line,
   unexecuted.
4. **opts** — a table. Always include `desc`.

`desc` is not decoration. It is what `:nmap` shows you, what a which-key style
plugin displays, and what you will use to find the mapping again in six months.
A config full of undescribed mappings is a config you cannot audit.

One default worth knowing now: `vim.keymap.set` is **non-recursive** by default —
the Lua equivalent of `:nnoremap`, not `:nmap`. That is the safe default and
almost always what you want. Pass `remap = true` when you deliberately want the
rhs to trigger other mappings.

Binding a key to **a function you wrote** is the same call with a Lua function in
the rhs slot, and it is what **lesson 23** is about. It needs functions and
closures (lesson 15) first, so this lesson stops at a string rhs on purpose.

## The reload loop

You will change this file hundreds of times. Restarting Neovim each time is slow
and, worse, it hides which change caused what.

```vim
:source ~/.config/hero/init.lua
```

re-runs the file in the running instance. Measured — editing `shiftwidth` and
re-sourcing:

```
before:                        shiftwidth=2
after sourcing a file setting 4: shiftwidth=4
after re-sourcing init.lua:    shiftwidth=2
```

So options are re-applied, and re-defining an existing keymap is silently fine —
it simply overwrites.

If the file you are editing *is* the config, `:source %` is shorter — `%` means
"the current file", which lesson 21 covers properly.

**Where the loop stops being trustworthy.** Re-sourcing is reliable for options
and keymaps, and that covers this lesson entirely. It stops being reliable once
your config has two features you have not met yet: `require`d modules, which are
cached and will *not* re-run (lesson 16), and autocommands, which accumulate
duplicates unless they are grouped (lesson 24). When a re-source stops matching a
fresh start, those are the two suspects, and the fix in both cases is a real
restart. Knowing the loop has an edge is the point; you will meet the edge on
schedule.

## Proving a change took effect

Three questions, three tools. This section is the one to keep.

### "What is this option set to?"

```vim
:set shiftwidth?
```

The trailing `?` means *ask*, not *set*. Without it, `:set shiftwidth` is a
different command that tries to set it and errors on a numeric option. Real output:

```
:set number?          -> number
:set shiftwidth?      -> shiftwidth=2
:set expandtab?       -> expandtab
```

Boolean options report as their own name, or the name with `no` prefixed:

```
:set noexpandtab?     -> noexpandtab
```

Note that querying `noexpandtab?` and `expandtab?` both just report the current
state — the `no` in the query is ignored, so you cannot tell from the answer which
way you asked.

### "*Which file* set it?"

This is the one that ends arguments, and it is underused.

```vim
:verbose set shiftwidth?
```

```
  shiftwidth=2
	Last set from ~/.config/hero-l4/init.lua (run Nvim with -V1 for more details)
```

Two lines: the value, then the origin. When a plugin quietly overrides something
you set, this names the file. `:verbose` works as a prefix on `set` and on `map`.

### "What is this key actually bound to?"

```vim
:nmap <leader>n
```

Real output, with a buffer-local and a remappable mapping added so every column
appears:

```
n  <Space>x    *@:echo 1<CR>
                 buffer local
n  <Space>y      :echo 2<CR>
                 remappable
n  <Space>n    * :nohlsearch<CR>
                 Clear search highlight
```

Decode it column by column, because the middle columns are where people misread:

- **Column 1** — the mode. `n` is Normal. A **space** here means the mapping
  applies to Normal, Visual, Select *and* Operator-pending at once. `:h map-listing`
  has the full table.
- **Then the lhs**, with `<leader>` **already expanded** — `<Space>n`, not
  `<leader>n`. This is the field that tells you whether your leader was set in
  time.
- **Then one or two flag characters, just before the rhs.** From `:h map-listing`
  verbatim: `*` means *not remappable*, `&` means *only script-local mappings are
  remappable*, `@` means *a buffer-local mapping*. So `*@` above is
  "non-recursive and buffer-local", and `<Space>y` — which was created with
  `remap = true` — has a blank there.
- **Then the rhs**, to the end of the line.
- **The indented line underneath** is `desc`. If it is missing, you did not set
  one.

The recognition rule for the flag column: **a bare `*` is the normal case.**
Everything `vim.keymap.set` creates has it, because non-recursive is the default.
Its *absence* is the thing to notice — it means somebody passed `remap = true`.

### And when something went wrong during startup

```vim
:messages
```

Startup errors are printed and then scroll away. `:messages` is the transcript.
If `vim.g.hero_config_loaded` comes back `nil`, this is where the reason is.

## Worked example

Add the search-highlight keymap and verify it three ways before trusting it.

**Step 1.** In `~/.config/hero/init.lua`, below the `mapleader` lines:

```lua
vim.keymap.set('n', '<leader>n', ':nohlsearch<CR>', { desc = 'Clear search highlight' })
```

**Step 2.** `:source %`.

**Step 3.** Verify the binding exists *and* that the leader expanded correctly:

```vim
:nmap <leader>n
```

You want `<Space>n` in the lhs column. Seeing `\n` means the `mapleader` line ran
after this one, or not at all.

**Step 4.** Verify it works: search for something so the highlight appears, then
press `<Space>n`.

**The wrong reading to reject.** Step 4 alone looks like sufficient proof, and it
is the only step most people do. It is the weakest of the three, because a *stale*
mapping also works. If you had previously sourced a version of this file where the
rhs was `:nohlsearch<CR>` and you have just changed it to something else, pressing
the key still clears the highlight — from the old binding — and you conclude your
edit took effect when it did not. Step 3 reads the *current* state out of Neovim
rather than inferring it from behavior. Prefer asking Neovim what it thinks over
concluding from what you observe; that habit is most of debugging a config.

## Distinctions worth keeping straight

| These look alike | but |
|---|---|
| `:set shiftwidth` / `:set shiftwidth?` | the first tries to *set* and errors; the `?` asks |
| `:set opt?` / `:verbose set opt?` | value / value **and** the file that set it |
| `vim.opt.x = v` / `vim.o.x = v` | both set; they differ on reading and on scope (lesson 18) |
| `<leader>` in source / `<Space>` in `:nmap` | the same mapping — the leader is expanded when it is *set* |
| `vim.keymap.set` / `:nmap` | `vim.keymap.set` is non-recursive by default, like `:nnoremap` |
| `*` in a map listing / no flag | non-recursive (the normal case) / `remap = true` was passed |
| `@` in a map listing / `*` | buffer-local / non-recursive — different columns of meaning |
| `:source %` / restarting | equivalent for options and keymaps; not for modules or autocommands |
| `ignorecase` alone / with `smartcase` | the first removes case-sensitive search entirely |
| "the key works" / "my edit took effect" | a stale mapping also works — see the worked example |

## Common errors

### `<leader>` mappings do nothing, and nothing errors

`mapleader` was set after the mapping was created, so the mapping is on `\`.
Confirm with `:nmap <leader>n` and look at the lhs column. Move the `mapleader`
line above every mapping.

### `E518: Unknown option: shiftwidth?`

You wrote `:set shiftwidth?` inside Lua — as `vim.cmd('set shiftwidth?')` — or
typed `:set` when you meant to query from Lua. From Lua, read the option, do not
issue a `:set` query.

### `E5108: Lua: [string "vim/_core/options"]:131: Unknown option 'nosuchoption'`

Transcribed from a real run of `vim.opt.nosuchoption = 1`. Neovim names the bad
option in the message. Usually a typo or a Vim option Neovim removed.

### `E5108: Lua: [string "vim/_core/options"]:339: Invalid option type 'string' for 'shiftwidth', should be number`

From `vim.opt.shiftwidth = "four"`. The message names the option, the type you
gave, and the type wanted — read all three before guessing.

### `E5112: Lua chunk: .../init.lua:3: unexpected symbol near '<eof>'`

An unfinished line — this one came from a file ending in `vim.opt.tabstop =`.
`<eof>` means Lua ran out of input while still expecting something. The reported
line is where Lua *gave up*, often one past the real mistake.

### A `<Tab>` still inserts a tab after you set `expandtab`

Check `:verbose set expandtab?`. If it reports being set from somewhere other than
your `init.lua`, something later overrode it. If it reports your file but the
buffer still misbehaves, the option is buffer-local and the buffer predates the
change — options and their scopes are lesson 18.

### `:source %` stopped matching a fresh start

You have added `require`d modules or autocommands. Restart. See the reload-loop
section; lessons 16 and 24 explain why.

## Check yourself

1. Why must `vim.g.mapleader` be set before `vim.keymap.set` runs, given that
   nothing errors if it is not?
2. You run `:nmap <leader>n` and the lhs column shows `\n`. What is wrong, and
   where is the fix?
3. Give the command that tells you *which file* set `'shiftwidth'`.
4. In a map listing, what do `*` and `@` each mean, and which is the normal case
   for a mapping made by `vim.keymap.set`?
5. Why is `ignorecase` without `smartcase` a worse setting than neither?
6. Your keymap's rhs is `':nohlsearch'` with no `<CR>`. What happens when you
   press the key?
7. You edited the rhs of an existing mapping, re-sourced, pressed the key, and it
   behaved as before. Name two different explanations and the one command that
   distinguishes them.
8. Name the two features that make `:source %` stop being equivalent to a restart.

<details><summary>Answers</summary>

1. `<leader>` is expanded at the moment the mapping is created, not when the key
   is pressed. A mapping created before `mapleader` is set is bound to the default
   leader `\` — permanently, and silently.
2. `mapleader` had not been set when that mapping was created. Move the
   `vim.g.mapleader` line above every `vim.keymap.set` call, then re-source.
3. `:verbose set shiftwidth?`
4. `*` means the mapping is not remappable; `@` means it is buffer-local. `*` is
   the normal case, because `vim.keymap.set` is non-recursive by default — its
   absence means `remap = true` was passed.
5. It removes your ability to search case-sensitively at all. With `smartcase`,
   typing a capital restores case sensitivity for that search.
6. `:nohlsearch` is typed onto the command line and left there, unexecuted,
   waiting for you to press Enter.
7. Either the edit did not take effect (so the old mapping is still installed), or
   it did and the new rhs happens to do the same thing. `:nmap <leader>n` shows the
   rhs currently installed, which distinguishes them.
8. `require`d modules, which are cached and do not re-run (lesson 16), and
   autocommands, which accumulate duplicates unless grouped (lesson 24).

</details>

## Key takeaways

- `vim.opt.x = v` sets an option. Reading options back, and the difference between
  `vim.opt`, `vim.o`, `vim.bo` and `vim.wo`, is lesson 18 and is genuinely not
  obvious — do not guess at it yet.
- `<leader>` is expanded when a mapping is created. Set `mapleader` before any
  mapping exists, and remember that this becomes a real ordering constraint once
  the config has modules and plugins.
- `vim.keymap.set` is non-recursive by default, and `desc` is how you audit your
  own config later.
- `:source %` is the fast loop, and it is trustworthy for options and keymaps.
  Modules and autocommands are where it stops being so.
- Ask Neovim rather than inferring from behavior: `:set x?` for the value,
  `:verbose set x?` for the file that set it, `:nmap lhs` for what a key really
  does, `:messages` for what scrolled past. A stale mapping still works, so
  "the key does the right thing" is not proof your edit landed.

## Lookup (not the lesson)

| Tag | For |
|---|---|
| `:h lua-guide-options` | the option tables, briefly; lesson 18 is the real treatment |
| `:h vim.opt` | and `:h vim.o` |
| `:h vim.keymap.set()` | the signature and every opt |
| `:h map-arguments` | what `silent`, `expr`, `nowait` and friends do |
| `:h map-listing` | the mode column and the `*` `&` `@` flags |
| `:h mapleader` | and `:h maplocalleader` |
| `:h 'ignorecase'` | and `:h 'smartcase'` — note the quotes, they are options |
| `:h :source` | re-running a file |
| `:h :messages` | the message transcript |
| `:h -V` | `-V1` for the verbose startup detail `:verbose` points at |

Now go to [`TASK.md`](TASK.md).
