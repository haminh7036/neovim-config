return {
  -- Cấu hình tự động chuyển bộ gõ tối ưu bằng vim.fn.system truyền list (chạy trực tiếp không qua shell, đồng bộ và không trễ)
  {
    "fcitx5-native",
    dir = vim.fn.stdpath("config"), -- đường dẫn dummy để không clone từ github
    lazy = false,
    config = function()
      local fcitx5state = 1
      local initial_fcitx_state = 1 -- Lưu trạng thái bộ gõ của hệ thống trước khi mở Neovim

      -- Tắt bộ gõ ngay lập tức đồng bộ (truyền bảng để chạy trực tiếp binary, cực nhanh dưới 3ms)
      local function fcitx_off_sync()
        vim.fn.system({ "fcitx5-remote", "-c" })
      end

      -- Bật bộ gõ ngay lập tức
      local function fcitx_on()
        vim.fn.system({ "fcitx5-remote", "-o" })
      end

      -- Chỉ kích hoạt nếu hệ thống có cài đặt fcitx5-remote
      if vim.fn.executable("fcitx5-remote") == 1 or vim.fn.executable("fcitx-remote") == 1 then
        
        -- Lấy trạng thái hệ thống ban đầu TRƯỚC KHI Neovim can thiệp tắt nó
        local init_output = vim.fn.system({ "fcitx5-remote" })
        initial_fcitx_state = tonumber(init_output:sub(1, 1)) or 1

        -- Sau đó mới tắt bộ gõ để vào Normal mode của Neovim
        fcitx_off_sync()

        -- 1. Khi thoát Insert mode: Lấy trạng thái và tắt đồng bộ ngay lập tức trước khi Neovim nhận phím tiếp theo
        vim.api.nvim_create_autocmd("InsertLeave", {
          callback = function()
            -- Lấy trạng thái hiện tại đồng bộ bằng vim.fn.system (luôn có stdout chính xác kể cả khi event loop bị block)
            local output = vim.fn.system({ "fcitx5-remote" })
            local status = tonumber(output:sub(1, 1)) or 1
            if status == 2 then
              fcitx5state = 2
              fcitx_off_sync()
            else
              fcitx5state = 1
            end
          end,
        })

        -- 2. Khi vào Insert mode: Khôi phục lại trạng thái cũ
        vim.api.nvim_create_autocmd("InsertEnter", {
          callback = function()
            if fcitx5state == 2 then
              fcitx_on()
            end
          end
        })

        -- 3. Khi chuyển buffer (ví dụ mở NvimTree), nhận focus hoặc khởi động:
        -- Luôn luôn ép tắt bộ gõ nếu không phải đang ở Insert mode để tránh preedit ở Normal mode
        vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
          callback = function()
            if vim.api.nvim_get_mode().mode ~= "i" then
              fcitx_off_sync()
            end
          end,
        })

        -- 4. Khi thoát hoàn toàn Neovim: Khôi phục lại trạng thái bộ gõ ban đầu của hệ thống
        vim.api.nvim_create_autocmd("VimLeavePre", {
          callback = function()
            if initial_fcitx_state == 2 then
              fcitx_on()
            end
          end,
        })
      end
    end
  }
}
