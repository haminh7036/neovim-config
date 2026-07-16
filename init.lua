-- Leader Key
vim.g.mapleader = " "

-- Bootstrap lazy.nvim (tự động cài đặt lazy.nvim nếu chưa có)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Cài đặt các plugin cần thiết
require("lazy").setup({
  -- Plugin cung cấp module 'base16-colorscheme' cho matugen.lua
  { "RRethy/nvim-base16" },

  -- Plugin duyệt cây thư mục (File Explorer)
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup({
        sort = {
          sorter = "case_sensitive",
        },
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = false,
        },
      })

      -- Cấu hình phím tắt Leader + e để tắt/mở cây thư mục
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle File Explorer" })
    end,
  },
})

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Line Number
vim.opt.number = true
vim.opt.relativenumber = true

-- Highlight Current Line
vim.opt.cursorline = true

-- Matugen Color Scheme Configuration
require("matugen").setup()
