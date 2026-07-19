return {
  "h-hg/fcitx.nvim",
  -- Load only if fcitx-remote or fcitx5-remote is executable
  cond = vim.fn.executable("fcitx5-remote") == 1 or vim.fn.executable("fcitx-remote") == 1,
  -- Load immediately at startup to ensure autocmds catch startup events
  lazy = false,
}
