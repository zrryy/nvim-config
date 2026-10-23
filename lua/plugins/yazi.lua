return {
	{
		"mikavilpas/yazi.nvim",
		version = "*",
		event = "VeryLazy",

		dependencies = {
			{ "nvim-lua/plenary.nvim", lazy = true },
		},

		keys = {
			{
				"<leader>fy",
				"<cmd>Yazi<cr>",
				desc = "Open Yazi at current file",
			},
			{
				"<leader>fY",
				"<cmd>Yazi cwd<cr>",
				desc = "Open Yazi in working directory",
			},
		},

		opts = {
			open_for_directories = true,
		},
	},
}
