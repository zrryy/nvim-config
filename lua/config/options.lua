local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs / indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- UI
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Files
opt.swapfile = false
opt.backup = false
opt.undofile = true

-- Clipboard
opt.clipboard = "unnamedplus"

-- Completion menu behaviour
opt.completeopt = { "menu", "menuone", "noselect" }

-- Better command-line experience
opt.showmode = false
opt.cmdheight = 1

-- Faster update time for diagnostics, CursorHold, etc.
opt.updatetime = 250

-- Use rounded borders for floating windows
vim.o.winborder = "rounded"

-- Tabline to show only filename
_G.nvim_tabline = function()
  local line = ""

  for tab = 1, vim.fn.tabpagenr("$") do
    local win = vim.fn.tabpagewinnr(tab)
    local buf = vim.fn.tabpagebuflist(tab)[win]

    local path = vim.fn.bufname(buf)
    local name = path ~= "" and vim.fn.fnamemodify(path, ":t") or "[No Name]"

    if tab == vim.fn.tabpagenr() then
      line = line .. "%#TabLineSel#"
    else
      line = line .. "%#TabLine#"
    end

    line = line .. "%" .. tab .. "T " .. name .. " "
  end

  return line .. "%#TabLineFill#%T"
end

vim.o.tabline = "%!v:lua.nvim_tabline()"
