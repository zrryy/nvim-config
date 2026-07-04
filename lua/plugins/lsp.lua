return {
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },

    opts = {
      ensure_installed = {
        "lua_ls",
        "ts_ls",
        "pyright",
      },

      -- Keep this false while learning.
      -- We explicitly call vim.lsp.enable() ourselves below.
      automatic_enable = false,
    },

    config = function(_, opts)
      require("mason").setup()
      require("mason-lspconfig").setup(opts)

      local capabilities = vim.lsp.protocol.make_client_capabilities()

      local ok, blink = pcall(require, "blink.cmp")
      if ok then
        capabilities = blink.get_lsp_capabilities(capabilities)
      end

      -- Apply these capabilities to all LSP servers.
      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      -- Lua config for editing your Neovim config.
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })

      -- Explicitly enable only the servers we care about.
      vim.lsp.enable({
        "lua_ls",
        "ts_ls",
        "pyright",
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, {
              buffer = event.buf,
              desc = desc,
            })
          end

          map("n", "gd", vim.lsp.buf.definition, "Go to definition")
          map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
          map("n", "gr", vim.lsp.buf.references, "Go to references")
          map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
          map("n", "K", vim.lsp.buf.hover, "Hover documentation")
          map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
          map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")

          map("n", "<leader>e", vim.diagnostic.open_float, "Show diagnostic")
          map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
          map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
          map("n", "<leader>dl", vim.diagnostic.setloclist, "Diagnostic list")
        end,
      })

      vim.diagnostic.config({
        virtual_text = true,
        underline = true,
        signs = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = true,
        },
      })
    end,
  },
}
