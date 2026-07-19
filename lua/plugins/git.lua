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
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
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

        -- Actions
        map("n", "<leader>gs", gs.stage_hunk, { desc = "Stage Hunk" })
        map("n", "<leader>gr", gs.reset_hunk, { desc = "Reset Hunk" })
        map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview Hunk" })
        map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, { desc = "Blame Line" })
        map("n", "<leader>gd", gs.diffthis, { desc = "Diff File" })
      end,
    },
  }
}
