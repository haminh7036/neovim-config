-- Plugin gợi ý và nhắc phím tắt thông minh
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    -- Lọc bỏ các gợi ý liên quan đến thao tác chuột (Mouse, Scroll...)
    filter = function(mapping)
      local lhs = mapping.lhs:lower()
      if lhs:find("mouse") or lhs:find("scroll") then
        return false
      end
      return true
    end,
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    -- Đăng ký các nhóm phím tắt dưới phím Leader
    wk.add({
      { "<leader>b", group = "Buffer" },
      { "<leader>c", group = "Code" },
      { "<leader>f", group = "Find" },
      { "<leader>g", group = "Git" },
      { "<leader>q", group = "Session/Quit" },
      { "<leader>s", group = "Search" },
    })

    -- Đăng ký phím tắt Leader + ? để mở bảng tra cứu phím tắt nhanh
    vim.keymap.set("n", "<leader>?", function()
      wk.show()
    end, { desc = "Keymap Help" })
  end,
}
