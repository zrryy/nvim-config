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
				"<leader>-",
				"<cmd>Yazi<cr>",
				desc = "Open Yazi at current file",
			},
			{
				"<leader>fy",
				"<cmd>Yazi cwd<cr>",
				desc = "Open Yazi in working directory",
			},
		},

		opts = {
			open_for_directories = true,
		},
	},
}
