return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        background = {     -- :h background
          light = "latte",
          dark = "mocha",
        },
        transparent_background = false,
        show_end_of_buffer = false,
        integration_default = true,
      })

      vim.cmd.colorscheme("catppuccin")

      -- Make Git diffs easier to scan, using IDE-style add/delete/change colours.
      vim.api.nvim_set_hl(0, "DiffAdd", {
        bg = "#203b2b",
      })
      vim.api.nvim_set_hl(0, "DiffDelete", {
        bg = "#4a262b",
      })
      vim.api.nvim_set_hl(0, "DiffChange", {
        bg = "#29344a",
      })
      vim.api.nvim_set_hl(0, "DiffText", {
        bg = "#66551f",
        bold = true,
      })

      -- Keep Gitsigns markers visible against the Catppuccin background.
      vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#a6e3a1" })
      vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#89b4fa" })
      vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#f38ba8" })
    end,
  },
}

