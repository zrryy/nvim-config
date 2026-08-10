local function open_default_branch_diff()
  local default_branch = vim.fn.systemlist({
    "git",
    "symbolic-ref",
    "--quiet",
    "--short",
    "refs/remotes/origin/HEAD",
  })[1]

  if default_branch == nil or default_branch == "" then
    for _, branch in ipairs({ "origin/main", "origin/master", "origin/releases" }) do
      vim.fn.system({ "git", "rev-parse", "--verify", branch })
      if vim.v.shell_error == 0 then
        default_branch = branch
        break
      end
    end
  end

  if default_branch == nil or default_branch == "" then
    vim.notify("Could not find the origin default branch", vim.log.levels.ERROR)
    return
  end

  vim.cmd("DiffviewOpen --imply-local " .. vim.fn.fnameescape(default_branch .. "...HEAD"))
end

local function next_hunk()
  if vim.wo.diff then
    vim.cmd("normal! ]c")
  else
    require("gitsigns").next_hunk()
  end
end

local function previous_hunk()
  if vim.wo.diff then
    vim.cmd("normal! [c")
  else
    require("gitsigns").prev_hunk()
  end
end

return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
    keys = {
      { "]c", next_hunk, desc = "Next git hunk" },
      { "[c", previous_hunk, desc = "Previous git hunk" },
      { "<leader>hp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview git hunk" },
      { "<leader>hs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage git hunk" },
      { "<leader>hr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset git hunk" },
      { "<leader>hb", "<cmd>Gitsigns blame_line<cr>", desc = "Blame current line" },
      { "<leader>hB", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle inline blame" },
      {
        "ih",
        "<cmd>Gitsigns select_hunk<cr>",
        mode = { "o", "x" },
        desc = "Select git hunk",
      },
    },
  },
  {
    "sindrets/diffview.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      -- Show old-side insertions as deletions, matching common IDE diff views.
      enhanced_diff_hl = true,
    },
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewFileHistory",
    },
    keys = {
      { "<leader>dv", "<cmd>DiffviewOpen<cr>", desc = "Open working tree diff" },
      {
        "<leader>db",
        open_default_branch_diff,
        desc = "Open branch diff against default branch",
      },
      {
        "<leader>dh",
        "<cmd>DiffviewFileHistory %<cr>",
        desc = "Open file git history",
      },
      { "<leader>dq", "<cmd>DiffviewClose<cr>", desc = "Close diff view" },
    },
  },
}
