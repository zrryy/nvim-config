return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",

    config = function()
      local parsers = {
        "bash",
        "css",
        "html",
        "java",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      }

      require("nvim-treesitter").install(parsers)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = parsers,
        callback = function(event)
          -- Fall back to Vim syntax until a requested parser is installed.
          pcall(vim.treesitter.start, event.buf)
        end,
      })
    end,
  },
}
