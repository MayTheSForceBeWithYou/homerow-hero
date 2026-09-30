# 01 — Modes and the operator + motion grammar

Most people learn Vim as a list of commands to memorize: `dw` deletes a word,
`x` deletes a character, `dd` deletes a line. That list never ends, and it is the
wrong model. Normal mode is a small **grammar** — an operator composed with a
motion — and once you can read it, commands you have never seen become obvious.
This lesson teaches the grammar and the one rule that makes people think Vim is
inconsistent when it is not: exclusive versus inclusive motions.

## What this lesson asks of you

Be able to predict, before you press the keys, exactly which characters a given
`{operator}{motion}` pair will affect — including the boundary character.

There is no config work in this lesson. Nothing is added to `~/.config/hero`.

## Modes are the reason one keyboard does everything

Vim has no modifier-key soup because the same keys mean different things in
different modes. The ones that matter now:

| Mode | You get there by | `q` means |
|---|---|---|
| **Normal** | `<Esc>` | start recording a macro |
| **Insert** | `i` `a` `o` `I` `A` `O` | type the letter q |
| **Visual** | `v` `V` `<C-v>` | nothing (extends selection differently) |
| **Operator-pending** | typing an operator, e.g. `d` | wait for a motion |
| **Command-line** | `:` `/` `?` | type the letter q |

**Operator-pending** is the one nobody mentions and the one that explains the
grammar. When you press `d`, Vim does not delete anything. It enters a mode whose
only job is to wait for you to say *how much*. Everything in this lesson happens
in that gap.

You can see the gap. Press `d` and stop. The cursor sits there, nothing has
changed, and Neovim is waiting. Press `<Esc>` to abandon it.

## The grammar

```text
{count} {operator} {count} {motion}
```

Read it as a sentence: *do this* **to** *that much text*.

The core operators:

| Operator | Does |
|---|---|
| `d` | delete |
| `c` | change (delete, then enter Insert) |
| `y` | yank (copy) |
| `>` `<` | indent, dedent |
| `gu` `gU` `g~` | lowercase, uppercase, toggle case |
| `=` | reindent |
| `!` | filter through an external command |

The core motions, with the distinction that matters in the third column:

| Motion | Moves to | Exclusive or inclusive |
|---|---|---|
| `w` | start of next word | exclusive |
| `W` | start of next WORD (space-separated) | exclusive |
| `e` | end of this word | **inclusive** |
| `b` | start of previous word | exclusive |
| `0` | column 1 | exclusive |
| `^` | first non-blank character | exclusive |
| `$` | end of line | **inclusive** |
| `f{char}` | next occurrence of `{char}` | **inclusive** |
| `t{char}` | just before next `{char}` | exclusive |
| `}` `{` | next / previous blank line | exclusive |
| `G` `gg` | last / first line | linewise |
| `j` `k` | down / up a line | **linewise** |

An operator plus a motion affects the text **between where the cursor is and
where the motion would take it**. That is the whole rule. `d` plus `w` deletes
from here to the start of the next word.

### Counts multiply, they do not choose

A count can go before the operator, before the motion, or both — and when both
are present they **multiply**. Measured on `a1 a2 a3 a4 a5 a6 a7`:

```
d2w   -> a3 a4 a5 a6 a7      two words gone
2dw   -> a3 a4 a5 a6 a7      identical
2d3w  -> a7                  six words gone, not two, not three
```

So `d2w` and `2dw` are the same command spelled two ways, and this is the answer
to "which one is right" — neither, they are one command. `2d3w` is where the rule
becomes visible.

### Doubling an operator makes it linewise

There is no motion in `dd`. Typing the operator twice means *this whole line*:

```
dd   delete this line
yy   yank this line
>>   indent this line
gUU  uppercase this line
```

and a count works as you would expect: `2dd` deletes two lines.

## Exclusive versus inclusive — the rule that looks like inconsistency

This is the section to slow down on. It is the reason `dw` and `de` behave
differently in a way that feels arbitrary until you know the rule.

- An **exclusive** motion does *not* include the character it lands on.
- An **inclusive** motion *does*.

Both measured on `the quick brown fox`, cursor on the `t` at column 1:

```
dw   ->  quick brown fox      deleted "the " -- including the space
de   ->   quick brown fox     deleted "the"  -- the space survives
```

Look at the second result carefully: there is a leading space. `w` is exclusive,
so it lands on the `q` and stops short of it — deleting `the` plus the space.
`e` is inclusive, so it lands on the final `e` of `the` and takes it — deleting
exactly `the` and nothing more.

The same split explains `f` and `t`:

```
dfo  -> wn fox         deleted through the o of "brown"
dto  -> own fox        deleted up to, not including, that o
```

`f` is inclusive: it takes the character it found. `t` is exclusive: it stops
before it. The mnemonic that actually helps is that `t` stands for *till* — you
go till the character, not onto it.

**The wrong reading to reject.** People conclude from `de` leaving a space that
`e` "leaves a space behind", and start avoiding `e`. It does not: `e` is doing
the more precise thing. `dw` is the one with a side effect — it eats the
separator. When you want to delete a word and close the gap, `dw` is right. When
you want to replace a word and keep the spacing, `e` or a text object (lesson 02)
is right. Neither is broken; they have different boundaries.

### `cw` is a deliberate exception

By the rule above, `cw` should change from here to the start of the next word —
swallowing the space. It does not. Measured:

```
cwTHE<Esc>   -> THE quick brown fox
ceTHE<Esc>   -> THE quick brown fox
```

Identical. When `w` is used with `c` and the cursor is on a non-blank, Vim
quietly treats it as `e`, because changing a word and deleting the space after it
is almost never what anyone means. This special case is documented at `:h cw`,
and it is worth knowing precisely because it is an exception — if you carry
"`w` is exclusive" into `cw` you will predict wrongly.

### Linewise motions promote the whole operation

`j` and `k` are linewise, so an operator applied to them takes entire lines, not
the characters between two cursor positions. On `one / two / three / four` with
the cursor on line 1:

```
dj   -> three ⏎ four
```

Both `one` and `two` are gone, completely. Not "from the cursor on line 1 to the
cursor on line 2" — two whole lines. This surprises people who expect a
character-wise range, and it is why `dj` is a reasonable way to delete a pair of
lines.

`d}` is exclusive and charwise, which shows the contrast. On
`p1a / p1b / (blank) / p2a` from the top:

```
d}   ->  ⏎ p2a
```

The blank line survives, because `}` lands on it and `}` is exclusive.

### One boundary case worth carrying

`dw` on the *last* word of a line does not join the lines. On
`the quick brown fox` with the cursor on `fox`, shown quoted so the whitespace is
visible:

```
dw   -> "the quick brown "
```

`w` would normally cross to the next line, but an operator with `w` stops at the
end of the line when the last word is on it. This is a special case in
`:h word`, and it is the reason `dw` feels safe at the end of a line.

Notice the trailing space in that result. The cursor was on the `f`, and an
operator only ever affects text from the cursor onward, so the space *before*
`fox` was never in range. If you wanted that space gone too you would need to
start from it — `dw` with the cursor on the space deletes only the space, giving
`"the quick brownfox"` — or reach for a text object, which lesson 02 covers.
This is the most common reason a delete "leaves a stray space": the space was
behind the cursor, not ahead of it.

## Worked example

Take this line, cursor on the `p` of `print`:

```
    print("hello, world")
```

**Goal:** change `hello, world` to `goodbye`, leaving the quotes and parentheses.

Work it out as a sentence before pressing anything. The operator is `c` —
change. The extent is "from just after the opening quote to just before the
closing quote". With only this lesson's motions, the move is: get inside the
quotes, then change to just before the closing quote.

```
f"      cursor onto the opening quote      -> at the "
l       one character right, now on h      -> at the h
ct"     change till the next "             -> deletes hello, world, enters Insert
goodbye then <Esc>
```

Result: `    print("goodbye")`.

The load-bearing choice is `ct"` and not `cf"`. `t` is exclusive, so it stops
before the closing quote and leaves it in place. `cf"` is inclusive — it would
take the quote too, and you would be typing the quote back by hand.

**The wrong reading to reject.** A beginner writing this reaches for `cw` and
presses it twice, or counts characters and types `12x`. Both work today and both
break tomorrow, because the text they are aimed at is a specific length. The
grammar version — operator plus a motion that *describes* the boundary — keeps
working when the string changes length. That is the actual payoff of the grammar,
and it is why counting characters is a habit worth losing now.

(Lesson 02 shows the shorter answer: `ci"`. It is better. But it is a text
object, not a motion, and the distinction matters.)

## Distinctions worth keeping straight

| These look alike | but |
|---|---|
| `dw` / `de` | `w` exclusive, eats the following space; `e` inclusive, keeps it |
| `df{c}` / `dt{c}` | `f` takes the target character; `t` stops before it |
| `d2w` / `2dw` | the same command; counts may sit either side of the operator |
| `2d3w` / `2dw` | counts **multiply** — six words versus two |
| `dd` / `dj` | both linewise; `dd` is one line, `dj` is two |
| `dj` / `d}` | `j` is linewise (whole lines); `}` is exclusive charwise |
| `cw` / `dw` | `cw` behaves as `ce` on a non-blank; `dw` does not |
| Normal / operator-pending | pressing `d` leaves Normal and changes nothing yet |
| `w` / `W` | `w` stops at punctuation; `W` only at whitespace |

## Common errors

### You pressed `d`, nothing happened, and now keys behave oddly

You are in operator-pending mode, waiting to supply a motion. Every key you press
is being read as a motion. Press `<Esc>`.

### `de` left a double space and you assume `e` is broken

It left a *single* space that was already there. `e` is inclusive and deletes
exactly the word. If you want the space gone too, that is `dw` — or `daw`, which
lesson 02 covers.

### `dt(` did not delete anything, and Neovim beeped

`t` and `f` search forward **on the current line only**. If the character is not
ahead of the cursor on this line, the motion fails, and a failed motion aborts
the operator without changing anything. That abort is a feature: a failed motion
never half-applies an edit.

### `:h w` opened the wrong page

Ambiguous tags are a real hazard and lesson 12 is about this. For a motion the
tag is the keystroke, and for a word-related concept it is a word: `:h w` does
give the motion, but `:h word` gives the definition of what a word *is* —
including the end-of-line special case above.

## Check yourself

1. `2d3w` — how many words, and why?
2. Buffer is `alpha beta gamma`, cursor at column 1. Give the result of `dw`
   and of `de`, spaces included.
3. You want to delete from the cursor up to but not including the next `;`.
   Which two keystrokes after `d`?
4. Why does `ct"` leave the closing quote but `cf"` not?
5. Without running it: on `one / two / three`, cursor on line 1, what does `dj`
   leave, and what does that tell you about `j`?
6. You press `d` by accident. What do you press, and what got modified?
7. `cw` on the `t` of `the` behaves like which other command, and why is that an
   exception rather than an example of the rule?

<details><summary>Answers</summary>

1. Six. Counts multiply: 2 × 3.
2. `dw` leaves `beta gamma`. `de` leaves ` beta gamma` — with a leading space,
   because `e` is inclusive and takes only `alpha`.
3. `t;` — so `dt;`. `t` is exclusive and stops before the target.
4. `t` is exclusive (stops before the `"`), `f` is inclusive (takes it).
5. `three`. Both whole lines vanish, because `j` is a linewise motion — the
   operator applies to entire lines, not to the characters between the two
   cursor positions.
6. `<Esc>`. Nothing was modified; an operator with no motion makes no change.
7. Like `ce`. It is an exception: Vim special-cases `w` under `c` on a non-blank
   so that changing a word does not swallow the following space. Applying the
   plain exclusive-motion rule would predict the wrong result.

</details>

## Key takeaways

- Normal mode is `{count}{operator}{count}{motion}`, and the counts multiply.
- Exclusive motions stop short of their target; inclusive ones take it. That
  single rule explains `dw` versus `de` and `dt` versus `df`.
- Doubling an operator makes it linewise; a linewise motion like `j` promotes the
  whole operation to whole lines.
- A failed motion aborts the operator without changing anything, which makes
  composing safe to experiment with.
- Describing a boundary with a motion beats counting characters, because the
  description survives the text changing length.
- `cw` acting as `ce` is a documented exception, not an illustration of the rule.

## Lookup (not the lesson)

| Tag | For |
|---|---|
| `:h operator` | the list of operators |
| `:h motion.txt` | the whole motion chapter |
| `:h exclusive` | and `:h inclusive` — the rule itself |
| `:h word` | what counts as a word, plus the end-of-line case |
| `:h cw` | the documented exception |
| `:h Operator-pending` | the mode |
| `:h count` | how counts combine |

Now go to [`TASK.md`](TASK.md).
