return {
  {
    "stevearc/conform.nvim",
    cmd = { "ConformInfo" },
    init = function()
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("conform_format_on_save", { clear = true }),
        desc = "Format on save",
        callback = function(args)
          if vim.bo[args.buf].buftype ~= "" then
            return
          end
          require("conform").format({
            bufnr = args.buf,
            timeout_ms = 1000,
            lsp_format = "fallback",
          })
        end,
      })
    end,
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },

        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },

        json = { "prettier" },
        yaml = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        markdown = { "prettier" },
        sql = { "pg_format" },
        python = { "isort", "black" },
        rust = { "rustfmt" },
      },
    },

    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({
            async = true,
            lsp_format = "fallback",
          })
        end,
        mode = { "n", "v" },
        desc = "Format file",
      },
    },
  },
}
