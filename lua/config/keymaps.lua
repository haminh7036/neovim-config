vim.g.mapleader = " "

-- Di chuyển giữa các cửa sổ (Split Navigation) bằng Ctrl + hjkl
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window" })

-- Chỉnh kích thước cửa sổ bằng Ctrl + các phím mũi tên
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Quản lý Buffer
vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })

vim.keymap.set("n", "<leader>bd", function()
  local bufs = vim.fn.getbufinfo({ buflisted = 1 })
  local cur = vim.api.nvim_get_current_buf()
  if #bufs <= 1 then
    vim.cmd("enew")
  else
    vim.cmd("bp")
  end
  vim.api.nvim_buf_delete(cur, { force = false })
end, { desc = "Close Buffer" })
vim.keymap.set("n", "<leader>bo", function()
  local current = vim.api.nvim_get_current_buf()
  local unsaved = 0
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
      if vim.bo[buf].modified then
        unsaved = unsaved + 1
      else
        pcall(vim.api.nvim_buf_delete, buf, { force = false })
      end
    end
  end
  if unsaved > 0 then
    vim.notify(string.format("%d buffer(s) have unsaved changes and were not closed", unsaved), vim.log.levels.WARN, { title = "Buffer" })
  end
end, { desc = "Close Other Buffers" })

vim.keymap.set("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>", { desc = "Toggle Pin" })
vim.keymap.set("n", "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", { desc = "Delete Non-Pinned Buffers" })
vim.keymap.set("n", "<leader>br", "<cmd>BufferLineCloseRight<cr>", { desc = "Close Buffers to the Right" })
vim.keymap.set("n", "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", { desc = "Close Buffers to the Left" })

-- Save File and return to Normal mode
vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File and Normal Mode" })

-- Nhảy tới/lùi lịch sử con trỏ (VSCode style)
vim.keymap.set("n", "<A-Left>", "<C-o>", { desc = "Go Back" })
vim.keymap.set("n", "<A-Right>", "<C-i>", { desc = "Go Forward" })

-- Move lines up/down
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Line Down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Line Up" })
vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Line Down" })
vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Line Up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Selection Down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Selection Up" })

-- Thoát terminal mode (áp dụng cho mọi terminal buffer)
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit Terminal Mode" })

-- Giữ con trỏ ở giữa màn hình khi cuộn trang và tìm kiếm
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll Down and Center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll Up and Center" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next Search Result and Center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Prev Search Result and Center" })

-- Thụt lề liên tục trong Visual mode (giữ nguyên vùng chọn)
vim.keymap.set("v", "<", "<gv", { desc = "Indent Left and Reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent Right and Reselect" })

-- Giữ nguyên clipboard khi Paste đè trong Visual mode
vim.keymap.set("x", "p", [["_dP]], { desc = "Paste without overwriting clipboard" })

-- Điều hướng danh sách Quickfix Native
vim.keymap.set("n", "[q", "<cmd>cprev<cr>", { desc = "Previous Quickfix Item" })
vim.keymap.set("n", "]q", "<cmd>cnext<cr>", { desc = "Next Quickfix Item" })

-- Bật/tắt các thành phần giao diện (UI Toggles)
if vim.lsp.inlay_hint then
  vim.keymap.set("n", "<leader>uh", function()
    local enabled = vim.lsp.inlay_hint.is_enabled()
    vim.lsp.inlay_hint.enable(not enabled)
    vim.notify("Inlay Hints: " .. (not enabled and "ON" or "OFF"))
  end, { desc = "Toggle Inlay Hints" })
end

vim.keymap.set("n", "<leader>ud", function()
  local ok, tiny = pcall(require, "tiny-inline-diagnostic")
  if ok then
    tiny.toggle()
  else
    local current = vim.diagnostic.config().virtual_text
    vim.diagnostic.config({ virtual_text = not current })
    vim.notify("Diagnostic Virtual Text: " .. (not current and "ON" or "OFF"))
  end
end, { desc = "Toggle Inline Diagnostics" })
