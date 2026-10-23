return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",

    opts = {
      preset = "modern",
      delay = 300,

      spec = {
        { "<leader>f", group = "Find" },
        { "<leader>c", group = "Code" },
        { "<leader>g", group = "Git" },
        { "<leader>h", group = "Git Hunk" },
      },
    },

    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({
            global = false,
          })
        end,
        desc = "Buffer local keymaps",
      },
    },
  },
}
