-- Debug Adapter Protocol (DAP) cho Go — tương đương Xdebug driver bên PHP.
-- nvim-dap-go tự động cấu hình adapter Delve (dlv), không cần khai báo tay.
-- Binary `dlv` được cài qua Mason (`:MasonInstall delve`), không dùng `go install`
-- để tránh phụ thuộc PATH của shell — Mason đảm bảo symlink `mason/bin/dlv` ổn định.
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "leoluz/nvim-dap-go",
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
      },
    },
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug: Continue" },
      { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
      { "<F12>", function() require("dap").step_out() end, desc = "Debug: Step Out" },

      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      {
        "<leader>dB",
        function() require("dap").set_breakpoint(vim.fn.input("Điều kiện breakpoint: ")) end,
        desc = "Conditional Breakpoint",
      },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle Debug UI" },
      { "<leader>dh", function() require("dap.ui.widgets").hover() end, desc = "Inspect Value Under Cursor" },

      { "<leader>dgt", function() require("dap-go").debug_test() end, desc = "Debug Nearest Go Test" },
      { "<leader>dgl", function() require("dap-go").debug_last_test() end, desc = "Debug Last Go Test" },
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      require("dap-go").setup()
      dapui.setup()

      -- Tự mở/đóng DAP UI theo vòng đời phiên debug
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Icon breakpoint đồng bộ style với sign diagnostics hiện có
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticInfo", linehl = "Visual" })
    end,
  },
}
