# Neovim Config

Personal Neovim configuration built from scratch. It stays small enough to debug, and plugins are added when they solve a real editing or review problem.

Language servers use `vim.lsp.config()` and `vim.lsp.enable()`.

## Goals

* Minimal but practical
* Easy to debug
* Modular file structure
* Modern LSP setup
* No full Neovim distro
* Add a plugin when it solves a real problem

## Requirements

```bash
brew install neovim git ripgrep fd stylua uv bun
```

Python formatters:

```bash
uv tool install black
uv tool install isort
uv tool update-shell
```

Prettier:

```bash
bun add --global prettier
```

If Bun binaries are not found:

```bash
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
```

Rust uses the `rustup` toolchain, including `rust-analyzer`, `rustfmt`, and `clippy`. `rust-analyzer` is not installed through Mason.

Java LSP (`jdtls`) is installed through Mason and runs on the Homebrew OpenJDK 21 path configured in `lua/plugins/lsp.lua`.

SQL formatting expects `pg_format` on `PATH`.

## Structure

```text
~/.config/nvim/
├── init.lua
├── lua/
│   ├── config/
│   │   ├── options.lua
│   │   ├── keymaps.lua
│   │   └── lazy.lua
│   └── plugins/
│       ├── autopairs.lua
│       ├── blink.lua
│       ├── colorscheme.lua
│       ├── conform.lua
│       ├── diffview.lua
│       ├── git.lua
│       ├── gitsigns.lua
│       ├── icons.lua
│       ├── lazydev.lua
│       ├── lazygit.lua
│       ├── lsp.lua
│       ├── telescope.lua
│       ├── treesitter.lua
│       ├── web-dev-icons.lua
│       ├── which-key.lua
│       └── yazi.lua
```

`git.lua` is the Git and diff setup used day to day. `gitsigns.lua`, `diffview.lua`, and `lazygit.lua` are older specs that still load beside it. `icons.lua` and `web-dev-icons.lua` both configure the same icon plugin.

## Plugin stack

| Plugin | Purpose |
| --- | --- |
| `lazy.nvim` | Plugin manager |
| `catppuccin` | Colourscheme |
| `telescope.nvim` | File and project search |
| `blink.cmp` | Completion |
| `mason.nvim` | LSP installer for Lua, TypeScript, Python, and Java |
| `mason-lspconfig.nvim` | Mason to LSP bridge |
| `nvim-lspconfig` | LSP server definitions |
| `lazydev.nvim` | Lua and Neovim API completion |
| `conform.nvim` | Formatting, including format on save |
| `nvim-treesitter` | Syntax highlighting |
| `nvim-autopairs` | Insert the closing bracket or quote |
| `yazi.nvim` | File manager |
| `gitsigns.nvim` | Hunks, stage, reset, and blame |
| `diffview.nvim` | Side-by-side diffs and file history |
| `snacks.nvim` | Lazygit integration |
| `which-key.nvim` | Leader-key hints |
| `nvim-web-devicons` | File icons |

## Editor defaults

* Leader is Space. Local leader is `\`.
* Indentation is 4 spaces.
* Search is case-insensitive unless the pattern contains a capital letter.
* Unmodified buffers reload when the file changes on disk.

## LSP servers

| Server | Language | Install |
| --- | --- | --- |
| `lua_ls` | Lua and Neovim config | Mason |
| `ts_ls` | JavaScript and TypeScript | Mason |
| `pyright` | Python | Mason. Uses `VIRTUAL_ENV`, then `venv` or `.venv` |
| `jdtls` | Java | Mason, run with OpenJDK 21 |
| `rust_analyzer` | Rust | `rustup` |

```vim
:checkhealth vim.lsp
:lua vim.print(vim.lsp.get_clients({ bufnr = 0 }))
:LspRestart
```

Rust warnings from `cargo check` refresh after a save. Type errors refresh after leaving Insert mode.

## Formatting

`:w` and `Space w` format before saving. `Space cf` formats without saving. Visual mode formats the selection.

| Filetype | Formatter |
| --- | --- |
| Lua | `stylua` |
| JavaScript, TypeScript, JSX, TSX | `prettier` |
| JSON, YAML, HTML, CSS, Markdown | `prettier` |
| Python | `isort`, then `black` |
| SQL, including `.psql` | `pg_format` |
| Rust | `rustfmt` |

```vim
:ConformInfo
```

## Keymaps

Press Space and wait to see leader groups. `Space ?` shows buffer-local maps.

### General

| Key | Action |
| --- | --- |
| `Space w` | Format and save |
| `Space q` | Quit the window |
| `Esc` | Leave Insert mode, or clear search highlight in Normal mode |
| `Ctrl-h/j/k/l` | Move between splits |
| `Ctrl-u` / `Ctrl-d` | Half-page up or down |
| `n` / `N` | Next or previous search match |
| `u` / `Ctrl-r` | Undo or redo. Disabled inside Diffview |

### Editing

| Key | Action |
| --- | --- |
| `ciw` | Change the word under the cursor |
| `c$` | Change to the end of the line |
| `ci"` | Change inside quotes |
| `dd` / `yy` / `p` | Delete, copy, or paste a line |
| `"_d` | Delete without replacing the last copy |
| `.` | Repeat the last change |
| `{`, `(`, `[`, `"`, `'` | Insert the closing character in Insert mode |

### Find

| Key | Action |
| --- | --- |
| `/text` | Search the open file |
| `*` | Search for the word under the cursor |
| `Space ff` | Find files |
| `Space fg` | Search text in the project |
| `Space fb` | Find open buffers |
| `Space fr` | Recent files |
| `Space fh` | Search help |

### Code

These apply when a language server is attached.

| Key | Action |
| --- | --- |
| `gd` / `gr` / `gi` / `gD` | Definition, references, implementation, declaration |
| `Ctrl-o` / `Ctrl-i` | Jump backward or forward |
| `K` | Hover documentation in Normal mode |
| `Space rn` | Rename symbol |
| `Space ca` | Code action |
| `]d` / `[d` | Next or previous diagnostic |
| `Space e` | Show the diagnostic under the cursor |
| `Space dl` | List diagnostics. `Enter` jumps, `q` closes |

### Completion

Handled by `blink.cmp` in Insert mode. Suggestions are highlighted before they are inserted.

| Key | Action |
| --- | --- |
| `Tab` / `Shift-Tab` | Next or previous suggestion |
| `Enter` | Accept the highlighted suggestion, or insert a newline when nothing is highlighted |
| `Ctrl-e` | Close the menu |
| `Ctrl-n` / `Ctrl-p` | Next or previous suggestion |

### Files

| Key | Action |
| --- | --- |
| `Space fy` | Open Yazi in the current file's directory |
| `Space fY` | Open Yazi in the working directory |

Inside Yazi: `r` renames the selected file, and `,M` sorts by modified time with the newest first.

### Git

| Key | Action |
| --- | --- |
| `Space dv` | Working-tree diff |
| `Space db` | Branch diff against the default branch |
| `Space dh` | History of the current file |
| `Space dq` | Close Diffview |
| `]c` / `[c` | Next or previous hunk |
| `Space hs` / `Space hr` | Stage or reset the hunk |
| `Space hp` | Preview the hunk |
| `Space hb` | Blame the current line |
| `Space hB` | Toggle inline blame |
| `Space gg` | Open Lazygit |

In Diffview, `gf` opens the real file for editing. Review panes stay read-only. Merge-conflict panes can be edited.

## Useful commands

| Command | Purpose |
| --- | --- |
| `:Lazy` | Manage plugins. `U` updates them |
| `:Mason` | Manage Mason-installed language servers |
| `:checkhealth` | General health check |
| `:ConformInfo` | Formatter status |
| `:LspRestart` | Restart language servers |
| `:TSUpdate` | Update Tree-sitter parsers |

## Updating tools

```bash
brew update && brew upgrade
uv tool upgrade --all
bun update --global prettier
rustup update
```

## Left out on purpose

* Debug adapter
* A separate lint plugin. Diagnostics come from the language server
* Statusline, bufferline, session manager, and project manager
* AI plugins
