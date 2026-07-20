return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    init = function()
      -- Đóng nvim-tree trước khi ghi session để không lưu lại window rỗng
      -- của file explorer (buffer ảo không thể khôi phục từ đĩa)
      vim.api.nvim_create_autocmd("User", {
        pattern = "PersistenceSavePre",
        callback = function()
          local ok, api = pcall(require, "nvim-tree.api")
          if ok then
            api.tree.close()
          end
        end,
      })
    end,
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
