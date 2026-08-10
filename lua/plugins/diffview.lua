local function open_default_branch_diff()
  local default_branch = vim.fn.systemlist({
    "git",
    "symbolic-ref",
    "--quiet",
    "--short",
    "refs/remotes/origin/HEAD",
  })[1]

  if not default_branch or default_branch == "" then
    for _, branch in ipairs({ "origin/main", "origin/master" }) do
      vim.fn.system({ "git", "rev-parse", "--verify", branch })

      if vim.v.shell_error == 0 then
        default_branch = branch
        break
      end
    end
  end

  if not default_branch or default_branch == "" then
    vim.notify(
      "Could not determine origin default branch",
      vim.log.levels.ERROR
    )
    return
  end

  vim.cmd(
    "DiffviewOpen --imply-local "
      .. vim.fn.fnameescape(default_branch .. "...HEAD")
  )
end

return {
  {
    "sindrets/diffview.nvim",

    dependencies = {
      "nvim-lua/plenary.nvim",
    },

    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewFileHistory",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
    },

    keys = {
      {
        "<leader>dv",
        "<cmd>DiffviewOpen<cr>",
        desc = "Working tree diff",
      },
      {
        "<leader>db",
        open_default_branch_diff,
        desc = "Branch diff against default",
      },
      {
        "<leader>dh",
        "<cmd>DiffviewFileHistory %<cr>",
        desc = "Current file history",
      },
      {
        "<leader>dq",
        "<cmd>DiffviewClose<cr>",
        desc = "Close Diffview",
      },
    },

    opts = {
      enhanced_diff_hl = true,

      default_args = {
        DiffviewOpen = {
          "--imply-local",
        },
      },

      view = {
        default = {
          layout = "diff2_horizontal",
          winbar_info = true,
        },

        merge_tool = {
          layout = "diff3_mixed",
          disable_diagnostics = true,
          winbar_info = true,
        },

        file_history = {
          layout = "diff2_horizontal",
          winbar_info = true,
        },
      },

      file_panel = {
        listing_style = "tree",

        tree_options = {
          flatten_dirs = true,
          folder_statuses = "only_folded",
        },

        win_config = {
          position = "left",
          width = 35,
        },
      },
    },
  },
}
