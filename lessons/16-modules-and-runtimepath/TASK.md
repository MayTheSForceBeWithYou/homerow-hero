# 16 — Task

Practice only. The teaching is in [`LESSON.md`](LESSON.md).

**This lesson changes `~/.config/hero`.** The reference snapshot is `config/16`, and it is
the first snapshot that is more than one file.

## 1. Split your config

Turn `~/.config/hero/init.lua` into:

```
~/.config/hero/
├── init.lua
└── lua/
    └── hero/
        ├── init.lua
        ├── options.lua
        └── keymaps.lua
```

1. Move the options — including the two leader lines — into `hero/options.lua`.
2. Move every `vim.keymap.set` call into `hero/keymaps.lua`.
3. `hero/init.lua` requires the two, in the order that matters.
4. `init.lua` becomes `require('hero')` plus the completion marker.

Each module needs `return` only if something calls into it. These two are run for their
side effects, so they need nothing — but write `local M = {}` … `return M` in one of them
anyway, just to see the shape.

**Done when** a real restart leaves `:set shiftwidth?`, `:nmap <leader>y` and
`:lua = vim.g.hero_config_loaded` exactly as they were before the split. The point of a
refactor is that nothing changes.

Then compare: `bash tools/use-snapshot.sh --diff 16`.

## 2. Prove the refactor changed nothing

Before and after are easy to *assume* and cheap to check. Write down, from the
pre-split config:

```vim
:set hidden? number? expandtab? shiftwidth? ignorecase? smartcase? incsearch? hlsearch?
:nmap <leader>y
:nmap ]q
:lua = vim.g.mapleader
```

Do the split. Restart. Run the same four commands and compare every value.

If anything differs, the most likely cause is load order — check that `options` is
required before `keymaps`.

## 3. Break the order deliberately

In `hero/init.lua`, swap the two `require` lines so `keymaps` runs first. Restart — a real
restart, not `:source`.

1. Press `<leader>y`. What happens?
2. Run `:nmap <leader>y` and read the lhs column.
3. Explain the result using lesson 04's rule.
4. Put the order back.

This is the same trap as lesson 04 step 3, and it is worth meeting again now that it lives
in a `require` ordering rather than a line ordering — because this is the form it takes in
a real config.

## 4. Feel the cache

1. Change `shiftwidth` in `hero/options.lua`.
2. `:source ~/.config/hero/init.lua`.
3. `:set shiftwidth?` — did it change?
4. Now `:lua package.loaded['hero.options'] = nil` and source again. Did it change now?
5. Restart and confirm.

Then answer: why did step 2 fail, and what exactly did step 4 do?

## 5. Write a reload helper, and find its limit

Add to `hero/init.lua` — or a scratch buffer — something like:

```lua
local function reload(name)
  package.loaded[name] = nil
  return require(name)
end
```

Use it to reload `hero.options` after an edit. It works.

Now find where it stops working:

1. Add a module `hero/util.lua` with a function, and bind a keymap to
   `require('hero.util').hello`.
2. Edit that function.
3. Reload `hero.util` with your helper.
4. Press the key. Which version runs?

Explain the result in terms of what a reload returns. This is the reason a restart is the
authoritative answer, and it is worth discovering rather than being told.

## 6. Answer "where is my module?" properly

Deliberately create the not-found error: `:lua require('hero.nope')`.

1. Read the path list. Where do those paths come from?
2. Is your config directory among them?
3. Now run
   ```vim
   := vim.api.nvim_get_runtime_file('lua/hero/options.lua', true)
   ```
   and compare what that tells you.
4. `:= vim.api.nvim_get_runtime_file('lua/hero/nope.lua', true)` — what does an empty
   list mean?

The point is to never again respond to that error by editing `package.path`.

## 7. Drills

```bash
./drill 16
```

Eighteen drills; two are `BUG HUNT`. Most build a fixture directory, prepend it to the
runtimepath, and write module files into it — so they exercise the real resolution
mechanism rather than a mock of it.

**Done when** `./drill 16` reports no `TODO` and no `FAIL`.

## 8. Write one drill

Add `exercises/19-mine-*.lua` covering something this lesson mentioned but did not drill:
`vim.loader.reset()`, `:scriptnames`, an `after/` directory winning over an earlier
runtimepath entry, `package.preload`, or a module that returns a function rather than a
table. Build your fixture with `vim.fn.tempname()` and `vim.opt.runtimepath:prepend`, and
clear `package.loaded[name]` first — module state persists between drills.
