return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(bufnr)
        local gs = require("gitsigns")

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Điều hướng
        map("n", "]c", function()
          if vim.wo.diff then return "]c" end
          vim.schedule(function() gs.next_hunk() end)
          return "<Ignore>"
        end, { expr = true, desc = "Next Git Hunk" })

        map("n", "[c", function()
          if vim.wo.diff then return "[c" end
          vim.schedule(function() gs.prev_hunk() end)
          return "<Ignore>"
        end, { expr = true, desc = "Prev Git Hunk" })

        -- Hành động
        map("n", "<leader>gs", gs.stage_hunk, { desc = "Stage Hunk" })
        map("n", "<leader>gr", gs.reset_hunk, { desc = "Reset Hunk" })
        map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview Hunk" })
        map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, { desc = "Blame Line" })
        map("n", "<leader>gd", gs.diffthis, { desc = "Diff File" })
        map("n", "<leader>ub", gs.toggle_current_line_blame, { desc = "Toggle Line Blame" })
      end,
    },
  },

  -- Quản lý & giải quyết Git conflict trực tiếp trong buffer
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      default_mappings = true,
      default_commands = true,
      -- Plugin gọi vim.diagnostic.disable() đã bị xóa ở Neovim 0.12 → lỗi mỗi lần redraw.
      -- Tắt option này, tự ẩn diagnostics qua User autocmd trong config bên dưới.
      disable_diagnostics = false,
      highlights = {
        incoming = "DiffAdd",
        current = "DiffText",
      },
    },
    config = function(_, opts)
      require("git-conflict").setup(opts)
      local group = vim.api.nvim_create_augroup("GitConflictDiagnostics", { clear = true })
      for event, enabled in pairs({ GitConflictDetected = false, GitConflictResolved = true }) do
        vim.api.nvim_create_autocmd("User", {
          group = group,
          pattern = event,
          callback = function() vim.diagnostic.enable(enabled, { bufnr = vim.api.nvim_get_current_buf() }) end,
        })
      end
    end,
  },

  -- Xem Git Diff & 3-Way Merge dạng Side-by-Side
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
    keys = {
      { "<leader>gD", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview File History" },
    },
  },
}
