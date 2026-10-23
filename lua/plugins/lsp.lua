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
        "jdtls",
      },
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

      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      vim.lsp.config("jdtls", {
        cmd_env = {
          JAVA_HOME = "/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home",
        },
      })

      -- Pyright resolves imports against whatever interpreter it finds, so an
      -- unactivated project venv shows up as missing third-party packages.
      local function venv_python(root)
        local candidates = {}

        if vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV ~= "" then
          table.insert(candidates, vim.env.VIRTUAL_ENV)
        end

        for _, name in ipairs({ "venv", ".venv", "env", ".env" }) do
          table.insert(candidates, vim.fs.joinpath(root or "", name))
        end

        for _, dir in ipairs(candidates) do
          local python = vim.fs.joinpath(dir, "bin", "python")
          if vim.uv.fs_stat(python) then
            return python
          end
        end
      end

      vim.lsp.config("pyright", {
        -- The client captures config.settings by reference before this runs, so
        -- the table has to be mutated in place rather than replaced.
        before_init = function(_, config)
          local python = venv_python(config.root_dir)
          if python then
            config.settings = config.settings or {}
            config.settings.python =
              vim.tbl_deep_extend("force", config.settings.python or {}, { pythonPath = python })
          end
        end,
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
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

      vim.lsp.enable({
        "lua_ls",
        "ts_ls",
        "pyright",
        "jdtls",
        "rust_analyzer",
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
