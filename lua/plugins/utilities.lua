return {
  -- Tự động đóng ngoặc, dấu nháy, v.v.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  -- Comment code nhanh bằng gc/gcc
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = true,
  },
}
