local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs / indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
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
opt.autoread = true

-- Refresh unmodified buffers when agents or other tools change files on disk.
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  callback = function()
    if vim.bo.buftype == "" then
      vim.cmd("checktime")
    end
  end,
})

-- Clipboard
opt.clipboard = "unnamedplus"

-- Completion menu behaviour
opt.completeopt = { "menu", "menuone", "noselect" }

-- Better command-line experience
opt.showmode = false
opt.cmdheight = 1

-- Show only filenames in the native tabline.
_G.nvim_tabline = function()
  local current_tab = vim.fn.tabpagenr()
  local tab_count = vim.fn.tabpagenr("$")
  local tabs = {}

  for tab = 1, tab_count do
    local buffers = vim.fn.tabpagebuflist(tab)
    local window = vim.fn.tabpagewinnr(tab)
    local buffer = buffers[window]
    local filename = vim.fn.bufname(buffer)

    if filename == "" then
      filename = "[No Name]"
    else
      filename = vim.fn.fnamemodify(filename, ":t")
    end

    local modified = vim.bo[buffer].modified and " +" or ""
    local highlight = tab == current_tab and "%#TabLineSel#" or "%#TabLine#"
    tabs[#tabs + 1] = string.format("%s%%%dT %d:%s%s ", highlight, tab, tab, filename, modified)
  end

  return table.concat(tabs) .. "%#TabLineFill#%T"
end

opt.tabline = "%!v:lua.nvim_tabline()"

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
