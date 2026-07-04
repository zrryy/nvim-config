local enabled_filetypes = {
  "c",
  "lua",
  "markdown",
  "vim",
  "vimdoc",
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = enabled_filetypes,
  callback = function()
    pcall(vim.treesitter.start)
  end,
})
