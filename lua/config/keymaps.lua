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

-- Quản lý Buffer
vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })

vim.keymap.set("n", "<leader>bd", "<Cmd>bp|bd #<CR>", { desc = "Close Buffer" })
vim.keymap.set("n", "<leader>bo", function()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.api.nvim_buf_is_loaded(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
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

-- LazyGit Floating Window
local function open_lazygit()
  if vim.fn.executable("lazygit") ~= 1 then
    vim.notify("lazygit is not installed or not in PATH", vim.log.levels.ERROR)
    return
  end

  local width = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.9)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  })

  vim.fn.termopen("lazygit", {
    on_exit = function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
      if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end,
  })
  vim.cmd("startinsert")
end

vim.keymap.set("n", "<leader>gg", open_lazygit, { desc = "LazyGit" })

-- Native Floating Terminal Toggle
local term_state = { buf = nil, win = nil }

local function toggle_terminal()
  if term_state.win and vim.api.nvim_win_is_valid(term_state.win) then
    vim.api.nvim_win_hide(term_state.win)
    term_state.win = nil
    return
  end

  if not term_state.buf or not vim.api.nvim_buf_is_valid(term_state.buf) then
    term_state.buf = vim.api.nvim_create_buf(false, true)
  end

  local width = math.floor(vim.o.columns * 0.85)
  local height = math.floor(vim.o.lines * 0.85)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  term_state.win = vim.api.nvim_open_win(term_state.buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " Terminal ",
    title_pos = "center",
  })

  -- Nếu buffer chưa có terminal channel thì khởi tạo
  if vim.bo[term_state.buf].buftype ~= "terminal" then
    vim.fn.termopen(vim.o.shell, {
      on_exit = function()
        if term_state.win and vim.api.nvim_win_is_valid(term_state.win) then
          vim.api.nvim_win_close(term_state.win, true)
          term_state.win = nil
        end
        if term_state.buf and vim.api.nvim_buf_is_valid(term_state.buf) then
          vim.api.nvim_buf_delete(term_state.buf, { force = true })
          term_state.buf = nil
        end
      end,
    })
  end

  vim.cmd("startinsert")
end

vim.keymap.set({ "n", "t" }, "<C-/>", toggle_terminal, { desc = "Toggle Floating Terminal" })
vim.keymap.set({ "n", "t" }, "<C-_>", toggle_terminal, { desc = "Toggle Floating Terminal" })
vim.keymap.set("n", "<leader>ft", toggle_terminal, { desc = "Terminal (Floating)" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit Terminal Mode" })

-- Giữ con trỏ ở giữa màn hình khi cuộn trang và tìm kiếm
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll Down and Center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll Up and Center" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next Search Result and Center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Prev Search Result and Center" })

-- Thụt lề liên tục trong Visual mode (giữ nguyên vùng chọn)
vim.keymap.set("v", "<", "<gv", { desc = "Indent Left and Reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent Right and Reselect" })

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
  local current = vim.diagnostic.config().virtual_text
  vim.diagnostic.config({ virtual_text = not current })
  vim.notify("Diagnostic Virtual Text: " .. (not current and "ON" or "OFF"))
end, { desc = "Toggle Diagnostic Virtual Text" })
