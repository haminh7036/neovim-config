return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    -- Phím tắt để khôi phục/quản lý session
    keys = {
      {
        "<leader>qs",
        function()
          require("persistence").load()
        end,
        desc = "Restore Session",
      },
      {
        "<leader>ql",
        function()
          require("persistence").load({ last = true })
        end,
        desc = "Restore Last Session",
      },
      {
        "<leader>qd",
        function()
          require("persistence").stop()
        end,
        desc = "Don't Save Session",
      },
    },
  },
}
