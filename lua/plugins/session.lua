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

      -- Tự động kích hoạt lại filetype, Treesitter, LSP sau khi session được nạp
      vim.api.nvim_create_autocmd("User", {
        pattern = "PersistenceLoadPost",
        callback = function()
          local buf = vim.api.nvim_get_current_buf()
          if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "" then
            if vim.bo[buf].filetype == "" then
              vim.cmd("filetype detect")
            end
            vim.api.nvim_exec_autocmds("BufReadPost", { buffer = buf })
          end
        end,
      })

      -- Tự động khôi phục session khi mở lại Neovim (không truyền file cụ thể)
      vim.api.nvim_create_autocmd("VimEnter", {
        group = vim.api.nvim_create_augroup("persistence_auto_restore", { clear = true }),
        callback = function()
          -- Bỏ qua nếu đọc từ stdin/pipe hoặc đang chạy diff mode
          if (vim.uv or vim.loop).guess_handle(0) == "pipe" or vim.g.started_with_stdin or vim.opt.diff:get() then
            return
          end

          local argc = vim.fn.argc()
          -- Khôi phục session nếu mở nvim không tham số hoặc chỉ mở thư mục
          if argc == 0 or (argc == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1) then
            vim.schedule(function()
              require("persistence").load()
            end)
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
