return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("catppuccin-mocha")
      -- Đặt màu nền nổi bật cho nhãn nhảy của Flash
      vim.api.nvim_set_hl(0, "FlashLabel", { bg = "#f38ba8", fg = "#11111b", bold = true })
    end,
  },
}
