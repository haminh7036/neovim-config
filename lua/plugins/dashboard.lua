return {
  -- Màn hình chào khi mở Neovim ở thư mục, không chỉ định file cụ thể
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      -- Chỉ bật module dashboard, các module khác của snacks.nvim giữ mặc định (tắt)
      dashboard = { enabled = true },
    },
  },
}
