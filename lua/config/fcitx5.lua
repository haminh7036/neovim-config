-- Chỉ kích hoạt nếu hệ thống có fcitx5-remote hoặc fcitx-remote
local fcitx_cmd = ""
if vim.fn.executable("fcitx5-remote") == 1 then
  fcitx_cmd = "fcitx5-remote"
elseif vim.fn.executable("fcitx-remote") == 1 then
  fcitx_cmd = "fcitx-remote"
else
  return
end

-- Bảng lưu trạng thái bộ gõ riêng biệt của từng buffer (Buffer-Local state)
-- Key: bufnr, Value: trạng thái (1: English, 2: Tiếng Việt)
local buffer_states = {}

-- Trạng thái bộ gõ bên ngoài hệ thống trước khi Neovim can thiệp
local external_system_state = 1

-- Danh sách các filetype đặc biệt cần bỏ qua (Luôn ép tắt tiếng Việt để gõ phím tắt Normal mode)
local ignore_filetypes = {
  ["NvimTree"] = true,
  ["fzf"] = true,
  ["lazy"] = true,
  ["mason"] = true,
  ["checkhealth"] = true,
  ["help"] = true,
}

-- Hàm tắt bộ gõ đồng bộ (truyền list để bypass shell con, cực nhanh dưới 3ms)
local function fcitx_off()
  vim.fn.system({ fcitx_cmd, "-c" })
end

-- Hàm bật bộ gõ
local function fcitx_on()
  vim.fn.system({ fcitx_cmd, "-o" })
end

-- Hàm lấy trạng thái bộ gõ hiện tại (đồng bộ)
local function fcitx_get_state()
  local output = vim.fn.system({ fcitx_cmd })
  return tonumber(output:sub(1, 1)) or 1
end

-- Lấy trạng thái hệ thống ban đầu trước khi can thiệp
external_system_state = fcitx_get_state()

-- Ép tắt bộ gõ về tiếng Anh ngay khi khởi động Neovim
fcitx_off()

local fcitx_group = vim.api.nvim_create_augroup("Fcitx5Native", { clear = true })

-- Đảm bảo tắt bộ gõ ngay khi Neovim vừa tải xong giao diện (VimEnter / UIEnter)
vim.api.nvim_create_autocmd({ "VimEnter", "UIEnter" }, {
  group = fcitx_group,
  callback = function()
    fcitx_off()
  end,
})

-- 1. Trước khi rời Insert mode: Lưu trạng thái của buffer hiện tại
vim.api.nvim_create_autocmd("InsertLeavePre", {
  group = fcitx_group,
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    buffer_states[bufnr] = fcitx_get_state()
  end,
})

-- 2. Khi rời Insert mode hoặc chuyển về Normal mode: LUÔN ép tắt Fcitx5 vô điều kiện (chống kẹt preedit)
vim.api.nvim_create_autocmd({ "InsertLeave", "ModeChanged" }, {
  group = fcitx_group,
  pattern = { "*", "*:n", "*:c" },
  callback = function()
    fcitx_off()
  end,
})

-- 3. Khi vào Insert mode: Khôi phục lại trạng thái cũ của đúng buffer đó
vim.api.nvim_create_autocmd("InsertEnter", {
  group = fcitx_group,
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local ft = vim.bo[bufnr].filetype
    if ignore_filetypes[ft] then
      fcitx_off()
      return
    end

    local target_state = buffer_states[bufnr] or 1
    if target_state == 2 then
      fcitx_on()
    end
  end,
})

-- 4. Khi chuyển buffer (BufEnter):
vim.api.nvim_create_autocmd("BufEnter", {
  group = fcitx_group,
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local ft = vim.bo[bufnr].filetype
    if ignore_filetypes[ft] then
      fcitx_off()
      return
    end

    local mode = vim.api.nvim_get_mode().mode
    if mode ~= "i" then
      fcitx_off()
    end
  end,
})

-- 5. Khi Neovim nhận lại focus (FocusGained):
vim.api.nvim_create_autocmd("FocusGained", {
  group = fcitx_group,
  callback = function()
    -- Ghi nhận trạng thái bên ngoài hệ thống trước khi Neovim can thiệp
    external_system_state = fcitx_get_state()

    local bufnr = vim.api.nvim_get_current_buf()
    local ft = vim.bo[bufnr].filetype
    if ignore_filetypes[ft] then
      fcitx_off()
      return
    end

    local mode = vim.api.nvim_get_mode().mode
    if mode == "i" then
      local target_state = buffer_states[bufnr] or 1
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

-- 6. Khi Neovim mất focus (FocusLost - chuyển sang tab khác / app khác):
-- Khôi phục lại đúng trạng thái bên ngoài trước đó của hệ thống
vim.api.nvim_create_autocmd("FocusLost", {
  group = fcitx_group,
  callback = function()
    if external_system_state == 2 then
      fcitx_on()
    else
      fcitx_off()
    end
  end,
})

-- 7. Khi đóng Neovim: Khôi phục lại đúng trạng thái ban đầu của hệ thống
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = fcitx_group,
  callback = function()
    if external_system_state == 2 then
      fcitx_on()
    else
      fcitx_off()
    end
  end,
})

-- 8. Phím tắt Esc ở Normal mode: Vừa tắt highlight tìm kiếm vừa ép xóa preedit & tắt Fcitx5
vim.keymap.set("n", "<Esc>", function()
  fcitx_off()
  vim.cmd("nohlsearch")
end, { desc = "Clear Highlight & Force IME Off" })
