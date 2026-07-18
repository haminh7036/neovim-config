vim.g.mapleader = " "

-- Di chuyển giữa các cửa sổ (Split Navigation) bằng Ctrl + hjkl
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window" })

-- Di chuyển giữa các cửa sổ bằng Ctrl + các phím mũi tên
vim.keymap.set("n", "<C-Left>", "<C-w>h", { desc = "Go to Left Window" })
vim.keymap.set("n", "<C-Down>", "<C-w>j", { desc = "Go to Lower Window" })
vim.keymap.set("n", "<C-Up>", "<C-w>k", { desc = "Go to Upper Window" })
vim.keymap.set("n", "<C-Right>", "<C-w>l", { desc = "Go to Right Window" })

-- Quản lý Buffer (Tab)
-- Đóng buffer hiện tại mà không làm hỏng bố cục cửa sổ split (Window splits)
vim.keymap.set("n", "<leader>x", "<Cmd>bp|bd #<CR>", { desc = "Close Current Buffer" })
vim.keymap.set("n", "<leader>bd", "<Cmd>bp|bd #<CR>", { desc = "Delete Buffer" })
