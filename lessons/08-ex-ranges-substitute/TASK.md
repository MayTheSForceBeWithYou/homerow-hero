# 08 — Task

Practice only. The teaching is in [`LESSON.md`](LESSON.md).

Nothing in this lesson changes `~/.config/hero`.

## 1. Drills

```bash
./drill 08
```

Twenty-four drills; two are `BUG HUNT`.

Read 08, 09 and 10 as a set: they isolate the `%`-versus-`g` distinction that
causes more wrong substitutions than anything else, and bug hunt 23 is that mistake
in the wild.

Drills 12 and 13 are the same substitution in the two pattern dialects. Type both,
then decide which you want to write for the rest of your life.

Drills 06 and 22 both operate on a visual range and get there differently — one lets
`:` prefill it, the other types it after leaving Visual mode. Doing both is what
makes the mechanism stick.

**Done when** `./drill 08` reports no `TODO` and no `FAIL`.

## 2. Stop typing line numbers

Open a file of at least 100 lines. For the next twenty minutes, do every
range-based edit **without reading a line number**:

- `.,+5` for "this line and the next five"
- `.,$` for "from here down"
- `1,.` for "from the top to here"
- `Vjjj:` and let the range write itself
- `/pattern/` as an address

Notice each time you scroll up to check a number. That is the habit being replaced.

## 3. Count before you change

Pick a real file and a pattern that appears often.

1. `:%s/pattern//gn` — note the count.
2. Now make the pattern slightly too broad on purpose (drop a `\<`, say) and count
   again.
3. Compare the two numbers.

That difference is what would have hit your file. Do this three times with different
patterns until running `n` first is automatic.

## 4. Learn the replacement side properly

On a scratch buffer, get each of these working. Do not move on until it does what
you predicted:

1. Wrap every occurrence of a word in backticks, without retyping the word.
2. Swap `key: value` into `value: key`.
3. Capitalise the first letter of every word on a line.
4. Uppercase an entire word but leave the rest of the line alone.
5. Turn `foo,bar,baz` into three lines. (Which escape — and what does the other one
   give you? Try both and look at the result with `:set list`.)
6. Replace a number with that number plus one. (You will need `\=`; `submatch(0)`
   gives you the match as a string.)

Number 5 is the one people get wrong and then blame on the terminal.

## 5. Use `\zs` for something real

Find a pattern in your own files where you want to change part of a match but need
the rest as context — a value after a key, a suffix after a prefix.

Write it twice: once with a capture group and `\1` in the replacement, once with
`\zs`. Compare the two commands and decide which you would rather read in six
months.

## 6. Read the flags

```vim
:h :s_flags
```

Answer from the page:

1. What does `c` do, and what are your options at each prompt? Try it on a real
   substitution and press every key it offers.
2. What does `&` as a *flag* mean, and how is that different from `&` as a command?
3. Find the flag that makes a substitution reuse the last search pattern.

Then look at `:h 'gdefault'` — you are not going to set it, but you need to
recognise it, because a config that sets it makes every `:s` behave as if `g` were
always on and every substitution you copy from the internet will then be wrong.

## 7. Write one drill

Add `exercises/25-mine-*.lua` using a range or replacement feature this lesson did
not drill: a mark-based range (`'a,'b`), `?pattern?` searching backwards, `\r` to
split a line, or `\=` with `submatch()`. Assert on the whole buffer, and remember
that `:s` without a range touches only the current line.
