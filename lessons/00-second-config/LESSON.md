# 00 — A second config, and what Neovim reads at startup

Everything else in this course depends on one habit: you experiment in a config
that is not the one you work in. Neovim has a built-in mechanism for this,
`NVIM_APPNAME`, and it redirects not just the config directory but the data,
state and cache directories too. This lesson sets that up, then walks the startup
sequence so that when a config misbehaves you know which of the eight steps you
are standing in.

## What this lesson asks of you

Create `~/.config/hero/init.lua`, start Neovim against it, and be able to say —
without guessing — which directory any given Neovim file lives in and at what
point during startup it is read.

You will not configure anything yet. Lesson 04 sets the first option. This lesson
is about the machinery underneath.

## The problem with one config

You have a working config at `~/.config/nvim`. It has lazy.nvim, twelve plugin
files, a C/C++ debugging setup you rely on. Learning means breaking things, and
breaking that means losing your editor in the middle of the workday.

The usual advice is "back it up and restore it". That is worse than it sounds: a
broken config often fails *partially* — half the plugins load, a keymap silently
disappears — and you spend an evening deciding whether the thing you changed
caused it. What you want is a second editor that shares nothing with the first.

## `NVIM_APPNAME` — one variable, four directories

Neovim decides where all its directories live from a single application name,
which defaults to `nvim` and which you can override:

```bash
NVIM_APPNAME=hero nvim
```

Here is what that actually changes. Run this yourself in a moment; for now, read
the two columns side by side:

| What | default | with `NVIM_APPNAME=hero` |
|---|---|---|
| config | `~/.config/nvim` | `~/.config/hero` |
| data (plugins) | `~/.local/share/nvim` | `~/.local/share/hero` |
| state (shada, undo) | `~/.local/state/nvim` | `~/.local/state/hero` |
| cache | `~/.cache/nvim` | `~/.cache/hero` |

Four separate directories, all renamed by one variable. That last detail is what
makes this safe rather than merely tidy: plugins install under *data*, so a
`hero` config downloads its own copy of lazy.nvim and cannot disturb the plugins
your real config has pinned. Your `~/.config/nvim/lazy-lock.json` is untouched
because nothing in `hero` ever reads it.

Neovim exposes these paths through `vim.fn.stdpath()`, and this is the function
to reach for any time you need to write a path into a config rather than
hardcoding one. Verified on this machine:

```
$ NVIM_APPNAME=hero nvim --headless -u NONE -l probe.lua
config   /home/n8/.config/hero
data     /home/n8/.local/share/hero
state    /home/n8/.local/state/hero
cache    /home/n8/.cache/hero
log      /home/n8/.local/state/hero
run      /run/user/1000/
```

Two of those rows are worth a second look. `log` is not its own directory — it
resolves to the same place as `state`. And `run` ignores the app name entirely,
because it is a per-user socket directory managed by the system, not by Neovim.
If you ever assume "every `stdpath` key gives me a distinct `hero` directory",
those two will surprise you.

### Making the alias permanent

Typing `NVIM_APPNAME=hero nvim` every time invites mistakes, and a mistake here
means editing your real config by accident. Give it a name. In `~/.zshrc`:

```bash
alias hero='NVIM_APPNAME=hero nvim'
```

From here on this course writes `hero` where it means "Neovim, running the
practice config".

## The eight steps of startup

When you run `nvim`, eight things happen in a fixed order. You do not need all
eight memorized, but you need to know where step 8 sits, because step 8 is your
config and almost every problem you will have is "something in step 8 ran before
the thing it depended on".

This is `:h initialization`, condensed:

| Step | What happens |
|---|---|
| 1 | Set `v:starttime`, `v:startreason` |
| 2 | Set `'shell'` from `$SHELL` |
| 3 | Process command-line arguments; `--cmd` commands run **here** |
| 4 | Start a server, set `v:servername` |
| 5 | Wait for a UI to connect (only with `--embed`) |
| 6 | Set up default mappings and autocommands |
| 7 | Enable filetype and indent plugins |
| 8 | **Load your config** |

Three consequences, and they are the reason this table is in a setup lesson
rather than an appendix:

- **`--cmd` runs at step 3, before your config; `-c` runs after it.** That is the
  difference between the two flags, and it is why debugging advice sometimes says
  `--cmd` specifically. When you need to set something *before* your config sees
  it, `--cmd` is the only flag that can.
- **Defaults exist before your config runs** (step 6). Your config overrides
  Neovim's defaults; it does not start from nothing.
- **Filetype plugins are already on** by the time your config runs (step 7). You
  do not need to enable them, and a config that does is copying Vim advice.

### Where your config file may live, and the one-file rule

At step 8, Neovim looks in the config directory for **`init.lua`** or
**`init.vim`** — and refuses to run if both exist:

```
$ NVIM_APPNAME=e5422-probe nvim --headless -c qa
E5422: Conflicting configs: "/home/n8/.config/e5422-probe/init.lua" "/home/n8/.config/e5422-probe/init.vim"
```

Read that message carefully, because it names both offenders and it is the
clearest error Neovim produces about config layout. This course writes Lua, so
`init.lua` is the file and `init.vim` must not exist beside it.

An empty config directory is legal. Neovim starts, and `$MYVIMRC` is simply
unset:

```
$ NVIM_APPNAME=empty-probe nvim --headless -c 'lua print(vim.env.MYVIMRC)' -c qa
nil
```

## Three ways to start without your config, and how they differ

You will use all three, for different reasons, and confusing them wastes hours.

| Flag | Reads your config? | Plugins loaded? | Filetype plugins? |
|---|---|---|---|
| `nvim --clean` | no | **yes** | **yes** |
| `nvim -u NORC` | no | **yes** | **yes** |
| `nvim -u NONE` | no | no | no |

Measured, not remembered:

```
$ nvim --headless --clean -l probe.lua
loadplugins=true  ft_plugin_loaded=1
$ nvim --headless -u NORC  -l probe.lua
loadplugins=true  ft_plugin_loaded=1
$ nvim --headless -u NONE  -l probe.lua
loadplugins=false ft_plugin_loaded=nil
```

So `--clean` and `-u NORC` give you **Neovim as shipped** — defaults on, bundled
plugins on, your config out of the picture. `-u NONE` gives you **Neovim as
bare as it gets**.

The difference matters when you are bisecting a problem. If a bug survives
`--clean`, it is not your config — it is Neovim or your terminal. If a bug
disappears under `--clean` but you want to know whether a *bundled* plugin is
involved, `-u NONE` is the next step down.

`--clean` and `-u NORC` also differ in one way the table cannot show, and it is
the wrong reading a competent beginner makes here. They are not synonyms:
`--clean` additionally removes your user directories from the runtimepath, while
`-u NORC` leaves them on it. Measured — these entries are present under
`-u NORC` and absent under `--clean`:

```
/home/n8/.config/nvim
/home/n8/.config/nvim/after
/home/n8/.local/share/nvim/site
/home/n8/.local/share/nvim/site/after
```

So under `-u NORC` your config file is skipped but your `after/` directory and
your `site/` plugins are still *findable* — a `:runtime` call or a colorscheme
lookup can still reach into them. `--clean` is the honest isolation of the two.
"`--clean` means no config" is right; "`-u NORC` means no config" is not quite,
and that gap is exactly where a confusing bisect result comes from.

## The runtimepath, first look

The `runtimepath` (usually written `rtp`) is the ordered list of directories
Neovim searches for anything loadable: plugins, colorschemes, filetype files,
Lua modules. Lesson 16 uses it in earnest; here, just see its shape. With an
empty `hero-probe` config:

```
/home/n8/.config/hero-probe          <- your config, searched first
/etc/xdg/hero-probe                  <- system-wide config
/home/n8/.local/share/hero-probe/site   <- your plugins
/usr/local/share/hero-probe/site
/usr/share/hero-probe/site
/usr/share/nvim/runtime              <- Neovim's own runtime files
/usr/lib/nvim
/usr/share/hero-probe/site/after
/usr/local/share/hero-probe/site/after
/home/n8/.local/share/hero-probe/site/after
/etc/xdg/hero-probe/after
/home/n8/.config/hero-probe/after    <- your overrides, searched last
```

The recognition rule: it is a **palindrome around `/usr/share/nvim/runtime`**.
Everything before it is a normal directory; everything after it is the same list
in reverse with `/after` appended. Your config is first, your `after/` is last.
That ordering is the entire mechanism behind "put it in `after/` to override a
plugin" — `after/` is last, so it wins.

Note also that every entry carries the app name: with `NVIM_APPNAME=hero-probe`
there is no `nvim` anywhere in that list except Neovim's own installed runtime.
That is the isolation, visible.

## Worked example

Let's create the practice config and prove it is separate.

**Step 1.** Create the directory and the file:

```bash
mkdir -p ~/.config/hero
cat > ~/.config/hero/init.lua <<'EOF'
-- ~/.config/hero/init.lua
-- The practice config for homerow-hero. Deliberately almost empty:
-- lesson 04 adds the first real setting.

vim.g.hero_config_loaded = true
EOF
```

**Step 2.** Start it and ask it where it is. Run `hero`, then type:

```vim
:lua = vim.fn.stdpath('config')
```

`:lua =` is shorthand for "evaluate this and show me the result" — you will use
it constantly from lesson 13 on. It should print:

```
/home/n8/.config/hero
```

**Step 3.** Prove the config actually ran, rather than Neovim merely starting:

```vim
:lua = vim.g.hero_config_loaded
```

which prints `true`. This is the check that matters. A config with a syntax error
part-way down still *starts* Neovim — you get an error message and then a usable
editor with half your settings applied. A variable set at the end of the file is
how you know the whole file ran.

**The wrong reading to reject here.** It is tempting to treat "Neovim opened
without complaining" as "my config loaded". It does not follow, and it is the
single most common way people lose an hour. Neovim is deliberately resilient: an
error at step 8 is reported and then startup continues. If you started `hero`
while `~/.config/hero` did not exist, you would get a perfectly normal-looking
editor — with no config at all. `vim.g.hero_config_loaded` distinguishes "Neovim
ran" from "my file ran", and that distinction is why the flag is in the file.

**Step 4.** Confirm the isolation from the other side. Still inside `hero`:

```vim
:lua = vim.fn.stdpath('data')
```

prints `/home/n8/.local/share/hero`. Compare it with what your real config
reports — start a second terminal, run plain `nvim`, and run the same command.
You will get `/home/n8/.local/share/nvim`. Different directory; nothing shared.

## Distinctions worth keeping straight

| These look alike | but |
|---|---|
| `--cmd {cmd}` / `-c {cmd}` | `--cmd` runs at step 3, **before** your config; `-c` runs after it |
| `--clean` / `-u NORC` | both skip your config and keep plugins, but `--clean` also drops your dirs from `rtp` |
| `-u NORC` / `-u NONE` | `NORC` keeps plugins and filetype plugins; `NONE` disables both |
| `stdpath('config')` / `stdpath('data')` | config is files you write; data is things Neovim and plugins install |
| `stdpath('state')` / `stdpath('cache')` | state is meant to survive (undo, shada); cache is disposable |
| config directory / runtimepath | the directory is one entry; the `rtp` is the whole ordered search list |
| "Neovim started" / "my config ran" | see the worked example — these are not the same claim |

## Common errors

### `E5422: Conflicting configs: ".../init.lua" ".../init.vim"`

Both files exist in the config directory. Neovim will not guess. Delete or rename
one. This bites people migrating from `init.vim` who create `init.lua` beside it.

### `E5112: Lua chunk: /home/n8/.config/hero/init.lua:3: unexpected symbol near '<eof>'`

Transcribed from a real run of a file ending in `vim.opt.tabstop =` with nothing
after it. `<eof>` means "end of file" — Lua ran out of input while still
expecting something. The line number is where Lua *gave up*, which is often one
line past the actual mistake, so look at the line before too.

### Nothing happens; `hero` behaves exactly like stock Neovim

Your config is not where you think. Check from inside Neovim:

```vim
:lua = vim.fn.stdpath('config')
:echo $MYVIMRC
```

If `$MYVIMRC` is empty, no config file was found at all — usually a typo in the
directory name, or `init.lua` created one level too deep.

### `:lua = vim.g.hero_config_loaded` prints `nil` although the file exists

The file was found but did not finish. Scroll back with `:messages` — the error
that stopped it was printed at startup and then scrolled away.

## Check yourself

1. You run `NVIM_APPNAME=hero nvim` and install a plugin. Which directory does it
   land in, and why can it not affect your real config?
2. At which startup step does your `init.lua` run, and name one thing that is
   already true before it does.
3. You need an option set *before* your config is read. Which command-line flag,
   and why not the other one?
4. A colleague says "`--clean` and `-u NORC` are the same thing". What is the one
   difference, and what symptom would reveal it?
5. Looking at the runtimepath listing above: without counting, how do you know
   which entry is searched last, and what is that used for?
6. Neovim opened with no error message. Does that prove your `init.lua` ran?

<details><summary>Answers</summary>

1. `~/.local/share/hero` — `stdpath('data')`. `NVIM_APPNAME` renames the data
   directory too, so the `hero` config installs its own plugins and never reads
   `~/.local/share/nvim` or your `lazy-lock.json`.
2. Step 8, last. Before it: `'shell'` is set (2), `--cmd` arguments have run (3),
   default mappings and autocommands exist (6), and filetype and indent plugins
   are enabled (7). Any one of those is a valid answer.
3. `--cmd`, because it runs at step 3 and your config at step 8. `-c` runs
   *after* the config, so the config would overwrite whatever you set.
4. `--clean` also removes `~/.config/nvim`, `~/.config/nvim/after` and
   `~/.local/share/nvim/site` from the runtimepath; `-u NORC` leaves them
   searchable. Symptom: under `-u NORC` a colorscheme or `:runtime` file from
   your own directories can still load, so a bug you thought you had isolated
   reappears.
5. It is the last line, `~/.config/hero-probe/after` — the list is a palindrome
   around `/usr/share/nvim/runtime`, so the reversed `after/` half comes last.
   Being last is what lets a file in `after/` override the same file from a
   plugin.
6. No. Neovim reports an error at step 8 and then continues starting. A flag
   variable set at the end of the file is what proves the file ran to completion.

</details>

## Key takeaways

- `NVIM_APPNAME` renames config, data, state and cache together. That is what
  makes a second config genuinely isolated rather than merely separate.
- Your config is step 8 of 8. Defaults, filetype plugins and `--cmd` arguments
  all precede it; `-c` commands follow it.
- `--clean`, `-u NORC` and `-u NONE` are three different amounts of "without my
  config", and picking the wrong one produces a misleading bisect.
- The runtimepath is a palindrome around Neovim's own runtime; `after/` is last,
  which is why `after/` wins.
- "Neovim started" is a weaker claim than "my config ran". Assert the second one
  on purpose.

## Lookup (not the lesson)

| Tag | For |
|---|---|
| `:h initialization` | the eight-step startup order |
| `:h NVIM_APPNAME` | the variable's exact semantics |
| `:h standard-path` | what each `stdpath` key means |
| `:h stdpath()` | the function signature |
| `:h --clean` | and, on the same page, `:h -u` |
| `:h 'runtimepath'` | note the quotes: it is an option, so the tag is quoted |
| `:h config` | where the config file may live |

Now go to [`TASK.md`](TASK.md).
