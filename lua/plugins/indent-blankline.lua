return {
  -- Đường kẻ thụt lề (indentation guides)
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "│" },
      -- Làm nổi bật khối thụt lề mà con trỏ đang đứng
      scope = {
        enabled = true,
        show_start = false,
        show_end = false,
      },
    },
  },
}
