# Neovim Config

Personal Neovim configuration built from scratch, focused on being minimal, modern, and easy to understand.

This config uses modern Neovim APIs, including `vim.lsp.config()` and `vim.lsp.enable()`, instead of the older `require("lspconfig").server.setup(...)` style.

## Goals

* Minimal but practical
* Easy to debug
* Modular file structure
* Modern LSP setup
* No full Neovim distro
* No Kickstart clone
* Add plugins only when they solve a real problem

## Requirements

Install the core dependencies:

```bash
brew install neovim git ripgrep fd stylua uv bun
```

Install Python formatters as isolated command-line tools:

```bash
uv tool install black
uv tool install isort
uv tool update-shell
```

Install Prettier globally with Bun:

```bash
bun add --global prettier
```

Verify that the formatters are available:

```bash
stylua --version
black --version
isort --version
prettier --version
```

If Bun-installed commands are not found, ensure its global binary directory is on your `PATH`:

```bash
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
```

## Updating

Update Neovim plugins:

```vim
:Lazy
```

Then press `U`.

Update Homebrew packages:

```bash
brew update
brew upgrade
```

Update Python tools:

```bash
uv tool upgrade --all
```

Update Prettier:

```bash
bun update --global prettier
```

Commit the resulting configuration changes:

```bash
git add .
git commit -m "update nvim config"
git push
```

## Structure

```text
~/.config/nvim/
├── init.lua
├── lua/
│   ├── config/
│   │   ├── options.lua
│   │   ├── keymaps.lua
│   │   ├── lazy.lua
│   │   └── treesitter.lua
│   └── plugins/
│       ├── blink.lua
│       ├── colorscheme.lua
│       ├── conform.lua
│       ├── lazydev.lua
│       ├── lsp.lua
│       └── telescope.lua
```

## Plugin Stack

| Plugin                 | Purpose                                        |
| ---------------------- | ---------------------------------------------- |
| `lazy.nvim`            | Plugin manager                                 |
| `tokyonight.nvim`      | Colourscheme                                   |
| `telescope.nvim`       | Fuzzy finder and project search                |
| `blink.cmp`            | Completion engine                              |
| `mason.nvim`           | Tool/LSP installer                             |
| `mason-lspconfig.nvim` | Mason to LSP config bridge                     |
| `nvim-lspconfig`       | LSP server configs                             |
| `lazydev.nvim`         | Better Lua/Neovim config development           |
| `conform.nvim`         | Formatting                                     |
| Native Tree-sitter     | Basic syntax parsing without `nvim-treesitter` |

## LSP Servers

Currently enabled:

| Server    | Language                |
| --------- | ----------------------- |
| `lua_ls`  | Lua / Neovim config     |
| `ts_ls`   | JavaScript / TypeScript |
| `pyright` | Python                  |

Check LSP status:

```vim
:checkhealth vim.lsp
```

Check active clients for current buffer:

```vim
:lua vim.print(vim.lsp.get_clients({ bufnr = 0 }))
```

## Formatting

Configured through `conform.nvim`.

| Filetype   | Formatter            |
| ---------- | -------------------- |
| Lua        | `stylua`             |
| JavaScript | `prettier`           |
| TypeScript | `prettier`           |
| JSX / TSX  | `prettier`           |
| JSON       | `prettier`           |
| YAML       | `prettier`           |
| HTML       | `prettier`           |
| CSS        | `prettier`           |
| Markdown   | `prettier`           |
| Python     | `isort` then `black` |

Check formatter status:

```vim
:ConformInfo
```

## Keymaps

Leader key:

| Key       | Meaning          |
| --------- | ---------------- |
| `<Space>` | Leader key       |
| `\`       | Local leader key |

### General

| Key         | Action                                   |
| ----------- | ---------------------------------------- |
| `<leader>w` | Save file                                |
| `<leader>q` | Quit window                              |
| `<Esc>`     | Clear search highlight                   |
| `<C-h>`     | Move to left split                       |
| `<C-j>`     | Move to lower split                      |
| `<C-k>`     | Move to upper split                      |
| `<C-l>`     | Move to right split                      |
| `<C-Up>`    | Increase window height                   |
| `<C-Down>`  | Decrease window height                   |
| `<C-Left>`  | Decrease window width                    |
| `<C-Right>` | Increase window width                    |
| `<C-d>`     | Half-page down and centre cursor         |
| `<C-u>`     | Half-page up and centre cursor           |
| `n`         | Next search result and centre cursor     |
| `N`         | Previous search result and centre cursor |

### Visual Mode

| Key | Action                   |
| --- | ------------------------ |
| `J` | Move selected lines down |
| `K` | Move selected lines up   |

### Telescope

| Key          | Action            |
| ------------ | ----------------- |
| `<leader>ff` | Find files        |
| `<leader>fg` | Live grep project |
| `<leader>fb` | Find open buffers |
| `<leader>fh` | Search help tags  |
| `<leader>fr` | Recent files      |

### LSP

These only apply when an LSP server is attached to the current buffer.

| Key          | Action                            |
| ------------ | --------------------------------- |
| `gd`         | Go to definition                  |
| `gD`         | Go to declaration                 |
| `gr`         | Go to references                  |
| `gi`         | Go to implementation              |
| `K`          | Hover documentation               |
| `<leader>rn` | Rename symbol                     |
| `<leader>ca` | Code action                       |
| `<leader>e`  | Show diagnostic under cursor      |
| `[d`         | Previous diagnostic               |
| `]d`         | Next diagnostic                   |
| `<leader>dl` | Send diagnostics to location list |

### Formatting

| Key         | Action                           |
| ----------- | -------------------------------- |
| `<leader>f` | Format current file or selection |

### Completion

Handled by `blink.cmp`.

Common defaults:

| Key         | Action                               |
| ----------- | ------------------------------------ |
| `<C-Space>` | Open completion menu / documentation |
| `<C-n>`     | Next completion item                 |
| `<C-p>`     | Previous completion item             |
| `<C-y>`     | Accept completion                    |
| `<C-e>`     | Hide completion menu                 |
| `<C-k>`     | Toggle signature help                |

## Useful Commands

| Command                | Purpose                       |
| ---------------------- | ----------------------------- |
| `:Lazy`                | Manage plugins                |
| `:Mason`               | Manage LSP/tool installations |
| `:checkhealth`         | General health check          |
| `:checkhealth vim.lsp` | LSP health check              |
| `:ConformInfo`         | Formatter status              |
| `:LazyDev`             | LazyDev debug info            |

## Updating

Update plugins:

```vim
:Lazy
```

Then press `U`.

Update formatters/tools manually when needed:

```bash
brew upgrade
npm update -g prettier
python -m pip install --upgrade black isort
```

Commit changes:

```bash
git add .
git commit -m "update nvim config"
git push
```

## Philosophy

This config avoids adding plugins too early. The rule is:

```text
One pain point → one plugin → one commit.
```

Current intentionally skipped plugins:

* File tree/sidebar
* Debug adapter / DAP
* Extra linting framework
* Full `nvim-treesitter` plugin setup
* Heavy statusline
* Bufferline
* Session manager
* Project manager
* AI plugins

