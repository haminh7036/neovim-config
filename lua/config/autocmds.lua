local function augroup(name)
  return vim.api.nvim_create_augroup("Native_" .. name, { clear = true })
end

-- 1. Highlight khi copy (Yank)
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.hl.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

-- 2. Khôi phục vị trí con trỏ khi mở lại file
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit", "gitrebase" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then
      return
    end
    vim.b[buf].last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- 3. Tự động tạo thư mục cha khi lưu file nếu chưa tồn tại
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%a%w+://") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- 4. Tự động cân bằng kích thước Split khi thay đổi kích thước cửa sổ
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- 5. Đóng nhanh các cửa sổ đọc tài liệu / popup bằng phím 'q'
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "checkhealth",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true, desc = "Quit Buffer" })
  end,
})

-- 6. Tự động reload buffer khi file thay đổi bên ngoài (git pull, checkout, lazygit...)
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- 7. Thông báo khi buffer được reload ngầm từ ổ đĩa
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = augroup("file_reloaded_notify"),
  callback = function(event)
    local file = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(event.buf), ":t")
    if file ~= "" then
      vim.notify("File '" .. file .. "' changed on disk. Buffer reloaded!", vim.log.levels.INFO)
    end
  end,
})

-- 8. Tắt tự động chèn ký tự comment khi xuống dòng mới
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("disable_auto_comment"),
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- 9. Tự động lưu khi mất focus hoặc chuyển buffer
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
  group = augroup("auto_save"),
  callback = function()
    if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
      vim.cmd("silent! update")
    end
  end,
})


