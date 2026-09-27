# homerow-hero

A self-study repo for experienced engineers to learn Vim/Neovim deeply, with emphasis on Vimscript and Neovim's Lua API.

## Curriculum roadmap

- `00-navigation/` — survival motions, operators, text objects, drills
- `01-configuration/` — `vimrc` vs `init.vim` vs `init.lua`, load order, option scopes, lazy.nvim internals
- `02-vimscript/` — scopes (`g: b: w: t: s: l: a:`), functions, autocommands, evaluation model
- `03-lua-api/` — `vim.api`, `vim.fn`, `vim.opt`, `vim.bo`/`vim.wo`, keymaps, commands, autocmds, object model
- `04-docs-navigation/` — practical `:help` indexing, `:helpgrep`, Vim concept ↔ Lua API mapping
- `05-lsp-builtin/` — Neovim 0.12 built-in LSP: `vim.lsp.config` / `vim.lsp.enable`, diagnostics, completion, formatting
- `06-capstone/` — save-before-compile workflow for MSVC `cl.exe`, buffer guards, quickfix integration
- `cheatsheets/` — one-page references
- `tests/` — headless verification scripts (one per lesson)

## Repo structure policy

Target state: each lesson directory contains a markdown lesson plus runnable Vimscript/Lua snippets for Neovim nightly (targeting 0.12 APIs). In this initial scaffold, `00-navigation/` is implemented first and the remaining lesson directories are placeholders.

## Verification

CI is the source of truth:

1. Pin and install Neovim nightly.
2. Run `stylua` on all Lua code.
3. Load every `*.lua` snippet headlessly with `nvim --headless -u NONE` and fail on errors.
4. Execute lesson verification scripts in `tests/`.
