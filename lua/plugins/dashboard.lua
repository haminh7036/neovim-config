-- Không có cmd thì Snacks.terminal mặc định mở split dưới đáy, ép float để giữ hành vi cũ
local function float_term()
  Snacks.terminal(nil, { win = { position = "float" } })
end

return {
  -- Màn hình chào khi mở Neovim ở thư mục, không chỉ định file cụ thể
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      -- Chỉ bật module dashboard; lazygit và terminal là module gọi theo yêu cầu, không cần bật
      dashboard = { enabled = true },
    },
    keys = {
      -- Snacks.lazygit đặt editPreset = "nvim-remote": bấm `e` trong lazygit mở file ở Neovim hiện tại
      { "<leader>gg", function() Snacks.lazygit() end, desc = "LazyGit" },
      { "<C-/>", float_term, mode = { "n", "t" }, desc = "Toggle Floating Terminal" },
      { "<C-_>", float_term, mode = { "n", "t" }, desc = "Toggle Floating Terminal" },
      { "<leader>ft", float_term, desc = "Terminal (Floating)" },
    },
  },
}
