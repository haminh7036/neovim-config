return {
  -- Tự động đóng ngoặc, dấu nháy, v.v.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- Hiển thị tiến trình LSP (loading, indexing...) ở góc màn hình
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {},
  },

  -- Tự nhận diện thụt lề (tab/space, độ rộng) theo từng file khi mở
  {
    "NMAC427/guess-indent.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
}

