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
    keys = {
      { "gcc", desc = "Comment toggle current line" },
      { "gc", mode = { "n", "o", "x" }, desc = "Comment toggle linewise" },
      { "gbc", desc = "Comment toggle current block" },
      { "gb", mode = { "n", "o", "x" }, desc = "Comment toggle blockwise" },
    },
    config = true,
  },
}
