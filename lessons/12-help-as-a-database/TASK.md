# 12 — Task

Practice only. The teaching is in [`LESSON.md`](LESSON.md).

Nothing in this lesson changes `~/.config/hero`. This is the last lesson of Phase C.

## 1. Drills

```bash
./drill 12
```

Eighteen drills; two are `BUG HUNT`. Both bug hunts resolve a tag **successfully** and
land on the wrong page, which is the failure this lesson exists to prevent — a lookup
that works and misleads is worse than one that errors.

**Done when** `./drill 12` reports no `TODO` and no `FAIL`.

## 2. Prove the namespace to yourself

Open `hero` and run each of these, noting the file you land in:

```vim
:h list
:h 'list'
:h :list
:h i_CTRL-W
:h CTRL-W
:h c_CTRL-W
```

Six commands, six destinations. Write them down. Then find a *seventh* spelling of a
word that resolves to more than one page — options and Ex commands that share a name
are the easiest hunting ground.

## 3. Use completion until you stop guessing

For each, type the prefix and press `<Tab>`, then `<C-d>`, and compare:

```vim
:h vim.keymap
:h nvim_buf_set
:h i_CTRL-
:h 'shift
```

`:h i_CTRL-<C-d>` is the complete list of Insert-mode control keys. Lesson 06 covered
about a third of them; look at the rest and find two you would actually use.

Then the wildcards:

```vim
:h *quickfix*
:h vim.*.set
:h *register*
```

Find one thing you did not know existed.

## 4. Escalate deliberately, four times

Pick four things you genuinely do not know how to do in Neovim. For each, work the
escalation in order and record which step found it:

1. tag completion on a guessed prefix
2. a wildcard
3. `:helpgrep`, then `:copen` and `]q`
4. `:h index`

The point is the record. If step one keeps failing, your model of the tag namespace
needs work; if step three always succeeds immediately, you are reaching for it too
early and getting hundreds of hits where a definition would do.

## 5. Read three pages once, properly

```vim
:h notation
```

Answer: what do `{}` and `[]` mean, and how is `<C-x>` written in the docs?

```vim
:h index
```

Search within it for a keystroke you were thinking of mapping. Is it already taken?

```vim
:h help-summary
```

This is the official version of this lesson. Read it and note anything it covers that
the lesson did not.

Then, in any long help file, press `gO`. That is the feature most people never find.

## 6. Connect it to lesson 10 and lesson 11

1. Open a help page. Run `:ls`, then `:ls!`. Explain the difference in terms of the
   flag columns from lesson 10.
2. Try to edit the help buffer. What stops you, and which option is it?
3. `:helpgrep vim%.keymap` then `:copen`. Navigate it with `]q` from `config/11`.
   Nothing new had to be learned — say why.

## 7. Find out what `K` does on your machine

```vim
:set keywordprg?
```

Then put the cursor on a word in a Lua file and press `K`. Then do the same in a shell
script. Explain both results.

Now decide: do you want `K` remapped? You do not have to change anything today — but
when an LSP configuration remaps it in a later phase, you will know what it displaced.

## 8. Write one drill

Add `exercises/19-mine-*.lua` covering a tag convention this lesson did not drill: a
pattern item (`/\zs`), a Visual-mode prefix (`v_`), an error number, or a whole help
file. Resolve the tag with `pcall(vim.cmd, 'help ' .. tag)` and assert on
`vim.fn.expand('%:t')`, and remember not to run the tag through `fnameescape` — a help
tag is not a filename, and escaping breaks the quoted option tags.
