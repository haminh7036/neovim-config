return {
  "junyixu/fcitx.nvim",
  -- Load only if fcitx-remote or fcitx5-remote is executable
  cond = vim.fn.executable("fcitx5-remote") == 1 or vim.fn.executable("fcitx-remote") == 1,
  -- Lazy load on InsertEnter to improve Neovim startup time
  event = "InsertEnter",
}
