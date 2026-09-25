return {
  -- Tự đổi commentstring theo ngôn ngữ nhúng (vd. JS trong <script> của HTML/Vue)
  -- dựa trên vùng Treesitter chứa con trỏ, thay vì dùng filetype cố định của cả file
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
