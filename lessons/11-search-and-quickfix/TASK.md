# 11 — Task

Practice only. The teaching is in [`LESSON.md`](LESSON.md).

**This lesson changes `~/.config/hero`.** The reference snapshot is `config/11`.

## 1. Add the navigation

In `~/.config/hero/init.lua`:

1. Set `incsearch` and `hlsearch`.
2. Map `]q` / `[q` to `:cnext` / `:cprevious`, and `<leader>q` / `<leader>Q` to
   `:copen` / `:cclose`.
3. Map `]l` / `[l` to the location-list twins.

The `[`/`]` shape is the built-in convention (`:h ]`) for stepping backwards and
forwards over a list — `[d` and `]d` in `config/04` already follow it. Using it here
means the whole family reads the same way.

**Done when** `:nmap ]q` shows `:cnext<CR>` and `:nmap [l` shows `:lprevious<CR>`.

Compare afterwards: `bash tools/use-snapshot.sh --diff 11`.

## 2. Learn the offsets by using them

On any file with repeated words:

1. `/word<CR>` — note the column.
2. `/word/e<CR>` — note the column. Now `d/word/e<CR>` and see what it deletes.
3. `/word/+1<CR>` — you are on the next line. Try `d/word/+1<CR>` and explain why it
   deleted whole lines.
4. Put the cursor on an identifier and press `*`. Look at what appears on the command
   line. Now press `g*` on the same word and compare.
5. Find a case where `*` finds the right thing and `g*` finds too much.

Step 4 is the one worth keeping: `*` is how you find an identifier, and knowing it
adds `\<\>` is why.

## 3. Search a real project

In a repo of your own:

```vim
:grep -w some_identifier
:copen
```

Then:

1. What does `:set grepprg?` report on this machine? Is ripgrep installed?
2. Step through with `]q`. What does the `(N of M)` message tell you?
3. `:clist` — use the entry numbers to jump straight to the fourth result with `:cc 4`.
4. Now run a second `:grep` for something else. What happened to your first list?
5. Do it again with `:lgrep` instead. What is different?
6. Try `:grepadd` for a third pattern. Check `:clist`.

Question 4 is the one that teaches why location lists exist.

## 4. Compare the two search engines

1. `:vimgrep /\v(alpha|beta)/j **/*.lua` — a Vim pattern with very magic syntax.
2. Now try the same pattern with `:grep`. What happens, and why?
3. Time both on a large tree. `:grep` should be dramatically faster.
4. Write down the rule you will actually use for choosing between them.

## 5. Do a real project-wide rename

Find something you genuinely want to rename. Then, carefully:

```vim
:grep -w old_name
:copen                                  " read every hit FIRST
:cdo s/\<old_name\>/new_name/ge | update
:grep -w old_name                       " should report nothing
```

Afterwards, deliberately break it to see the failure modes:

1. Drop the `\<` and `\>`. Run it on a file containing both `old_name` and
   `old_name_helper`. What happened?
2. Drop the `e` flag on a list where two entries are on the same line. Where did it
   stop, and did it tell you?
3. Drop `update`. Where are your changes, and what does `:ls` show?

Each of those three is a quiet failure. Seeing them once is worth more than reading
about them.

## 6. Drills

```bash
./drill 11
```

Nineteen drills; two are `BUG HUNT`. Most build a temporary fixture tree and `:cd`
into it, so they are slower than earlier lessons' drills and they exercise a part of
the runner that earlier lessons did not.

**Done when** `./drill 11` reports no `TODO` and no `FAIL`.

## 7. Read the list from Lua

This is a bridge to Phase D, so it is worth doing now even though `vim.fn` is lesson
21.

```vim
:lua = vim.fn.getqflist()[1]
```

Answer from the output:

1. What are the field names of a quickfix entry?
2. Which field holds the buffer, and how would you turn that into a filename?
3. Look at `:h setqflist()`. What would it take to build a quickfix list yourself,
   from data that did not come from a search?

That last question is the whole reason quickfix matters beyond searching: it is a
generic "list of places" that anything can fill.

## 8. Write one drill

Add `exercises/20-mine-*.lua` covering something this lesson did not drill: `:cfdo`
against `:cdo` on a file with several matches, `:grepadd`, `:cc` with an entry number,
or `setqflist()` building a list by hand. Build your fixture with `vim.fn.tempname()`
and `vim.fn.writefile()` as the other drills do — the runner restores the working
directory afterwards, so a `:cd` in your drill is safe.
