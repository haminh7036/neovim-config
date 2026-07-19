return {
  -- Bộ quản lý Fcitx5 Native chuyên nghiệp, bao quát mọi trường hợp, tối ưu cho Neovim 0.12+
  {
    "fcitx5-native",
    dir = vim.fn.stdpath("config"), -- đường dẫn dummy để chạy local không clone từ github
    lazy = false,
    config = function()
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
      
      -- Trạng thái bộ gõ ban đầu của hệ thống trước khi mở Neovim
      local initial_system_state = 1

      -- Danh sách các filetype đặc biệt cần bỏ qua (Luôn ép tắt tiếng Việt để gõ phím tắt Normal mode)
      local ignore_filetypes = {
        ["NvimTree"] = true,
        ["TelescopePrompt"] = true,
        ["fzf"] = true,
        ["alpha"] = true,
        ["dashboard"] = true,
        ["lazy"] = true,
        ["mason"] = true,
        ["checkhealth"] = true,
        ["help"] = true,
        ["gitcommit"] = true,
        ["gitrebase"] = true,
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
      initial_system_state = fcitx_get_state()

      -- Ép tắt bộ gõ về tiếng Anh lúc khởi động Neovim
      fcitx_off()

      local fcitx_group = vim.api.nvim_create_augroup("Fcitx5Native", { clear = true })

      -- 1. Khi rời Insert mode: Lưu trạng thái của buffer hiện tại và tắt bộ gõ
      vim.api.nvim_create_autocmd("InsertLeave", {
        group = fcitx_group,
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()
          local current_state = fcitx_get_state()
          buffer_states[bufnr] = current_state
          if current_state == 2 then
            fcitx_off()
          end
        end,
      })

      -- 2. Khi vào Insert mode: Khôi phục lại trạng thái cũ của đúng buffer đó
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

      -- 3. Khi chuyển buffer (BufEnter):
      -- Nếu đang ở Normal mode, đảm bảo tắt bộ gõ. Nếu là buffer đặc biệt (ví dụ NvimTree), ép tắt hoàn toàn.
      vim.api.nvim_create_autocmd("BufEnter", {
        group = fcitx_group,
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()
          local ft = vim.bo[bufnr].filetype
          if ignore_filetypes[ft] then
            fcitx_off()
            return
          end

          -- Nếu không ở Insert mode, luôn tắt bộ gõ ở Normal mode
          local mode = vim.api.nvim_get_mode().mode
          if mode ~= "i" then
            fcitx_off()
          end
        end,
      })

      -- 4. Khi Neovim nhận lại focus (FocusGained):
      -- Nếu đang ở Normal mode, tắt bộ gõ (phòng trường hợp bạn vừa bật tiếng Việt ở app khác rồi quay lại)
      vim.api.nvim_create_autocmd("FocusGained", {
        group = fcitx_group,
        callback = function()
          local mode = vim.api.nvim_get_mode().mode
          if mode ~= "i" then
            fcitx_off()
          end
        end,
      })

      -- 5. Khi Neovim mất focus (FocusLost):
      -- Khôi phục lại trạng thái bộ gõ của buffer hiện tại ra ngoài hệ thống để bạn gõ chữ ở app khác bình thường
      vim.api.nvim_create_autocmd("FocusLost", {
        group = fcitx_group,
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()
          local target_state = buffer_states[bufnr] or 1
          if target_state == 2 then
            fcitx_on()
          else
            fcitx_off()
          end
        end,
      })

      -- 6. Khi đóng Neovim: Khôi phục lại trạng thái bộ gõ ban đầu của hệ thống
      vim.api.nvim_create_autocmd("VimLeavePre", {
        group = fcitx_group,
        callback = function()
          if initial_system_state == 2 then
            fcitx_on()
          else
            fcitx_off()
          end
        end,
      })
    end,
  },
}
