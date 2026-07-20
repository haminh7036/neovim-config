return {
  -- Trình quản lý gói Mason
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ui = {
        border = "rounded",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
    end,
  },

  -- Cấu hình LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "Saghen/blink.cmp",
    },
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "LspInfo", "LspStart", "LspStop", "LspRestart" },
    keys = {
      { "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
    },
    config = function()
      
      -- Khai báo các LSP server tại đây.
      -- mason-lspconfig sẽ tự động cài đặt chúng.
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
            },
          },
        },
        -- Đặt cấu hình các LSP server khác tại đây
      }

      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup({
        ensure_installed = vim.tbl_keys(servers),
      })

      -- Lấy capabilities từ blink.cmp
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Tự thiết lập server để tránh API setup_handlers đã deprecated trong mason-lspconfig mới
      local lspconfig = require("lspconfig")
      local installed_servers = mason_lspconfig.get_installed_servers()

      -- Gộp danh sách server đã cài với danh sách server đã cấu hình
      local all_servers = {}
      for _, server in ipairs(installed_servers) do
        all_servers[server] = servers[server] or {}
      end
      for server_name, server_opts in pairs(servers) do
        all_servers[server_name] = server_opts
      end

      for server_name, server_opts in pairs(all_servers) do
        server_opts.capabilities = capabilities
        vim.lsp.config(server_name, server_opts)
        vim.lsp.enable(server_name)
      end

      -- Phím tắt LSP toàn cục
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
      vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "References" })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
      vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename Symbol" })
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev Diagnostic" })
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
    end,
  }
}
