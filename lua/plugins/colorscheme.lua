return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("catppuccin-mocha")
      -- ponytail: Hardcoded Catppuccin Mocha hex colors for Flash badge. Upgrade path: use Catppuccin custom_highlights if dynamic flavor switching is needed.
      vim.api.nvim_set_hl(0, "FlashLabel", { bg = "#f38ba8", fg = "#11111b", bold = true })
    end,
  },
}
