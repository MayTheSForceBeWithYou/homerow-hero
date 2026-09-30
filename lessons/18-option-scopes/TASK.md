# 18 — Task

Practice only. The teaching is in [`LESSON.md`](LESSON.md).

**This lesson changes `~/.config/hero`.** The reference snapshot is `config/18`. This is the
first lesson of Phase E.

## 1. Annotate what you already have

Open `~/.config/hero/lua/hero/options.lua`. For each option already in it, write a comment
answering one question: **should a buffer or window opened later inherit this?**

Every one of them should answer yes — they are global defaults, which is why `vim.opt` is
right for all of them. Writing it down once is what stops you reaching for `vim.opt` from
inside an autocommand later.

Then add:

1. A **list** option — `wildignore` is the natural one — assigned as a Lua list, then
   extended with `:append`.
2. A **map** option — `listchars` — extended with `:append` rather than reassigned.

**Done when** `:= vim.opt.wildignore:get()` shows a table and `:set listchars?` shows your
additions alongside the defaults.

Compare afterwards: `bash tools/use-snapshot.sh --diff 18`.

## 2. Build the scope table yourself

Do not take the lesson's table on trust. In a scratch session, for each writer below: reset
both scopes to 8, apply the writer, then report both.

```lua
local function probe(label, apply)
  local b = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_set_current_buf(b)
  vim.api.nvim_set_option_value('shiftwidth', 8, { scope = 'global' })
  vim.api.nvim_set_option_value('shiftwidth', 8, { buf = b })
  apply()
  print(label,
    vim.api.nvim_get_option_value('shiftwidth', { buf = b }),
    vim.api.nvim_get_option_value('shiftwidth', { scope = 'global' }))
end
```

Run it for `vim.o`, `vim.opt`, `vim.opt_local`, `vim.opt_global`, `vim.bo`, `vim.go`, and
for `:set`, `:setlocal`, `:setglobal`.

Predict each row before you see it. The one worth being wrong about is `vim.o`.

## 3. Reproduce the leak

1. Open a real Lua file in `hero`.
2. `:lua vim.o.shiftwidth = 2`
3. `:enew` — a brand-new buffer. `:set shiftwidth?`
4. Now start over and use `:lua vim.bo.shiftwidth = 2` instead. Repeat step 3.

Step 3 is the bug in lesson 24's autocommands before you have written them. Having seen it
once, you will not write `vim.o` in a `FileType` handler.

## 4. Ask options about themselves

```vim
:= vim.api.nvim_get_option_info2('shiftwidth', {})
```

Read the whole table — there is more in it than `scope`. Then answer for five options you
actually care about:

| Option | scope | global_local | which table would you write it with? |
|---|---|---|---|

Pick ones from your real config. If any answer surprises you, that is an option you have
been setting by luck.

## 5. Feel the global-local fallback

```vim
:set statusline=GLOBAL
:split
:lua vim.api.nvim_set_option_value('statusline', 'WINLOCAL', { win = 0 })
```

1. Compare the two windows' status lines.
2. Now clear the local one: set it to `''`. What happens, and why is that not "empty"?
3. Find another global-local option and confirm it behaves the same way.

## 6. Use the Option object for what it is for

```vim
:= vim.opt.listchars:get()
```

Then, without reassigning the whole thing:

1. Append an entry.
2. Remove one.
3. Read it back as a table, and as a raw string.

Finally, do it wrong on purpose: `:= vim.opt.shiftwidth + 1`. Look at what comes back, then
`:lua print(string.format('%d', vim.opt.shiftwidth))` and read the error.

## 7. Drills

```bash
./drill 18
```

Twenty drills; two are `BUG HUNT`. Drills 04, 05 and 06 are the scope table — do them in
order and predict each before running it.

**Done when** `./drill 18` reports no `TODO` and no `FAIL`.

## 8. Write one drill

Add `exercises/21-mine-*.lua` for something this lesson mentioned but did not drill:
`vim.opt_global`, a window-scoped option read with `nvim_get_option_value({ win = … })`,
`vim.opt` on a boolean option, or an option whose `global_local` value surprised you in
step 4. Reset both scopes at the start — options persist between drills, and the runner
restores them only between drills, not within one.
