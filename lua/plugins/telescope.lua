return {
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")

      telescope.setup({})

      pcall(telescope.load_extension, "fzf")

      -- Updated: Added hidden = true and no_ignore = true to find hidden files
      vim.keymap.set("n", "<leader>ff", function()
        builtin.find_files({ hidden = true, no_ignore = true })
      end, { desc = "Find files (including hidden)" })

      -- Updated: Passed --hidden and --no-ignore flags to ripgrep
      vim.keymap.set("n", "<leader>fg", function()
        builtin.live_grep({
          additional_args = function()
            return { "--hidden", "--no-ignore" }
          end
        })
      end, { desc = "Live grep (including hidden)" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
      vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
    end,
  },
}
