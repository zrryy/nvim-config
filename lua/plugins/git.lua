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

local function goto_file_edit()
  require("diffview.actions").goto_file_edit()

  if vim.bo.buftype == "" and not vim.wo.diff then
    vim.bo.modifiable = true
  end
end

local function in_diffview_file()
  local tabpage = vim.t[vim.api.nvim_get_current_tabpage()]
  return vim.wo.diff or (tabpage and tabpage.diffview_view_initialized and vim.bo.buftype ~= "nofile")
end

local function next_hunk()
  if in_diffview_file() then
    vim.cmd("normal! ]c")
  else
    require("gitsigns").next_hunk()
  end
end

local function previous_hunk()
  if in_diffview_file() then
    vim.cmd("normal! [c")
  else
    require("gitsigns").prev_hunk()
  end
end

local function reset_hunk()
  if not in_diffview_file() then
    require("gitsigns").reset_hunk()
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local was_modifiable = vim.bo[bufnr].modifiable
  vim.bo[bufnr].modifiable = true

  require("gitsigns").reset_hunk(nil, nil, function(err)
    if vim.api.nvim_buf_is_valid(bufnr) then
      vim.bo[bufnr].modifiable = was_modifiable
    end
    if err then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end)
end

local function configure_diffview_buffer(args)
  local view = require("diffview.lib").get_current_view()
  local entry = view and view.cur_entry
  local is_conflict = entry and entry.kind == "conflicting"

  if vim.bo[args.buf].buftype ~= "nofile" then
    vim.bo[args.buf].modifiable = is_conflict
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
      { "<leader>hr", reset_hunk, desc = "Reset git hunk" },
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
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "DiffviewDiffBufRead",
        callback = configure_diffview_buffer,
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "DiffviewDiffBufWinEnter",
        callback = function()
          vim.opt_local.wrap = true
          vim.opt_local.linebreak = true
          vim.opt_local.breakindent = true
        end,
      })
    end,
    opts = {
      -- Show old-side insertions as deletions, matching common IDE diff views.
      enhanced_diff_hl = true,
      keymaps = {
        view = {
          {
            "n",
            "gf",
            goto_file_edit,
            { desc = "Open the file in the previous tabpage" },
          },
        },
        file_panel = {
          {
            "n",
            "gf",
            goto_file_edit,
            { desc = "Open the file in the previous tabpage" },
          },
        },
      },
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
