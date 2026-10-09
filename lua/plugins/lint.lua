-- Linter async (chạy nền, không block UI) — golangci-lint cho Go
return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufWritePost", "BufReadPost", "InsertLeave" },
    keys = {
      { "<leader>cL", function() require("lint").try_lint() end, desc = "Lint Buffer" },
    },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        go = { "golangcilint" },
      }

      -- clear = true: tránh đăng ký trùng autocmd khi config chạy lại (`:Lazy reload nvim-lint`)
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("nvim_lint", { clear = true }),
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
