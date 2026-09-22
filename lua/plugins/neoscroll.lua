return {
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    config = function()
      require("neoscroll").setup({
        mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
        hide_cursor = true,          -- Ẩn con trỏ khi đang cuộn để tránh nháy
        stop_eof = true,             -- Dừng cuộn khi hết file
        use_local_scrolloff = false,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
        easing = "quadratic",        -- Easing bậc 2 cho hiệu ứng cuộn (giống cách VSCode cuộn)
        performance_mode = false,
      })
    end,
  },
}
