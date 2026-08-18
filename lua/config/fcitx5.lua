-- =======================================================================
-- Native Fcitx5 / Libuv IME Management
-- =======================================================================
-- RATIONALE:
-- Manages dynamic Fcitx5 states across Insert/Normal/Terminal modes
-- and syncs seamlessly with desktop focus events (FocusGained/FocusLost).
-- =======================================================================

local fcitx_cmd = ""
if vim.fn.executable("fcitx5-remote") == 1 then
  fcitx_cmd = "fcitx5-remote"
elseif vim.fn.executable("fcitx-remote") == 1 then
  fcitx_cmd = "fcitx-remote"
else
  return
end

-- Bảng lưu trạng thái bộ gõ riêng của từng buffer (1: English, 2: Tiếng Việt)
local buffer_states = {}

-- Danh sách filetype / buftype cần ép tắt tiếng Việt để phím tắt hoạt động an toàn
local ignore_filetypes = {
  ["NvimTree"] = true,
  ["fzf"] = true,
  ["lazy"] = true,
  ["mason"] = true,
  ["checkhealth"] = true,
  ["help"] = true,
}

local function is_ignored_buffer(bufnr)
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    return true
  end
  local ft = vim.bo[bufnr].filetype
  local bt = vim.bo[bufnr].buftype
  return ignore_filetypes[ft] or bt == "terminal" or bt == "nofile" or bt == "quickfix" or bt == "prompt"
end

-- Tắt bộ gõ đồng bộ (truyền list để bypass shell con, tốc độ < 1ms)
local function fcitx_off()
  vim.fn.system({ fcitx_cmd, "-c" })
end

-- Bật bộ gõ
local function fcitx_on()
  vim.fn.system({ fcitx_cmd, "-o" })
end

-- Lấy trạng thái hiện tại (1: Tắt / English, 2: Bật / Vietnamese)
local function fcitx_get_state()
  local output = vim.fn.system({ fcitx_cmd })
  return tonumber(output:sub(1, 1)) or 1
end

-- Ghi nhận trạng thái hệ thống ban đầu khi khởi động Neovim
local initial_state = fcitx_get_state()
local has_lost_focus = false

-- Ép về tiếng Anh cho Normal mode khi khởi động
fcitx_off()

local fcitx_group = vim.api.nvim_create_augroup("Fcitx5Native", { clear = true })

-- 1. Khi chuẩn bị thoát Insert mode: Lấy trạng thái TRƯỚC KHI mode đổi và tắt IME
-- QUAN TRỌNG: Phải dùng InsertLeavePre vì sự kiện này chạy trước ModeChanged,
-- đảm bảo đọc đúng trạng thái 2 (Tiếng Việt) trước khi bất kỳ lệnh tắt IME nào can thiệp.
vim.api.nvim_create_autocmd("InsertLeavePre", {
  group = fcitx_group,
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    if not is_ignored_buffer(bufnr) then
      buffer_states[bufnr] = fcitx_get_state()
    end
    fcitx_off()
  end,
})

-- 2. Khi vào Insert mode: Khôi phục đúng trạng thái của buffer hiện tại (hoặc initial_state)
vim.api.nvim_create_autocmd("InsertEnter", {
  group = fcitx_group,
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    if is_ignored_buffer(bufnr) then
      fcitx_off()
      return
    end

    local target_state = buffer_states[bufnr] or initial_state
    if target_state == 2 then
      fcitx_on()
    else
      fcitx_off()
    end
  end,
})

-- 3. Khi chuyển buffer (BufEnter):
vim.api.nvim_create_autocmd("BufEnter", {
  group = fcitx_group,
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local mode = vim.api.nvim_get_mode().mode
    if mode == "i" and not is_ignored_buffer(bufnr) then
      local target_state = buffer_states[bufnr] or initial_state
      if target_state == 2 then
        fcitx_on()
      else
        fcitx_off()
      end
    else
      fcitx_off()
    end
  end,
})

-- 4. Khi Neovim nhận focus (FocusGained):
vim.api.nvim_create_autocmd("FocusGained", {
  group = fcitx_group,
  callback = function()
    if has_lost_focus then
      initial_state = fcitx_get_state()
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local mode = vim.api.nvim_get_mode().mode
    if mode == "i" and not is_ignored_buffer(bufnr) then
      local target_state = buffer_states[bufnr] or initial_state
      if target_state == 2 then
        fcitx_on()
      else
        fcitx_off()
      end
    else
      fcitx_off()
    end
  end,
})

-- 5. Khi Neovim mất focus (FocusLost - chuyển tab terminal / cửa sổ khác):
-- Khôi phục chính xác trạng thái bên ngoài hệ thống
vim.api.nvim_create_autocmd("FocusLost", {
  group = fcitx_group,
  callback = function()
    has_lost_focus = true
    if initial_state == 2 then
      fcitx_on()
    else
      fcitx_off()
    end
  end,
})

-- 6. Thoát lệnh Command-line (: hoặc /): Đảm bảo về Normal mode sạch
vim.api.nvim_create_autocmd("CmdlineLeave", {
  group = fcitx_group,
  callback = function()
    fcitx_off()
  end,
})

-- 7. Khi đóng Neovim: Khôi phục lại trạng thái ban đầu của hệ thống
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = fcitx_group,
  callback = function()
    if initial_state == 2 then
      fcitx_on()
    else
      fcitx_off()
    end
  end,
})

-- 8. Phím tắt Esc ở Normal mode: Xóa highlight tìm kiếm và ép tắt IME dứt điểm
vim.keymap.set("n", "<Esc>", function()
  fcitx_off()
  vim.cmd("nohlsearch")
end, { desc = "Clear Highlight & Force IME Off" })
