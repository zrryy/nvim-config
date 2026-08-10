return {
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>fy", "<cmd>Yazi<cr>", desc = "Open Yazi" },
      { "<leader>fY", "<cmd>Yazi cwd<cr>", desc = "Open Yazi at working directory" },
    },
    opts = {
      open_for_directories = false,
    },
  },
}
