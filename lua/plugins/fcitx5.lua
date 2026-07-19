return {
  -- Cấu hình tự động chuyển bộ gõ tối ưu bằng Native Libuv spawn (không độ trễ)
  {
    "fcitx5-native",
    dir = vim.fn.stdpath("config"), -- đường dẫn dummy để không clone từ github
    lazy = false,
    config = function()
      local fcitx5state = 1
      local uv = vim.uv or vim.loop

      -- Tắt bộ gõ ngay lập tức (không chạy qua shell con nên không trễ)
      local function fcitx_off()
        uv.spawn("fcitx5-remote", { args = { "-c" } }, function() end)
      end

      -- Bật bộ gõ ngay lập tức
      local function fcitx_on()
        uv.spawn("fcitx5-remote", { args = { "-o" } }, function() end)
      end

      -- Lấy trạng thái bộ gõ bất đồng bộ
      local function fcitx_save_state()
        local stdout = uv.new_pipe(false)
        local handle
        handle, _ = uv.spawn("fcitx5-remote", {
          args = {},
          stdio = { nil, stdout, nil }
        }, function()
          if handle then handle:close() end
        end)
        
        local data = ""
        stdout:read_start(function(err, chunk)
          if chunk then
            data = data .. chunk
          else
            stdout:close()
            fcitx5state = tonumber(data:sub(1, 1)) or 1
          end
        end)
      end

      -- Chỉ kích hoạt nếu hệ thống có cài đặt fcitx5-remote
      if vim.fn.executable("fcitx5-remote") == 1 or vim.fn.executable("fcitx-remote") == 1 then
        vim.api.nvim_create_autocmd("InsertLeave", {
          callback = function()
            fcitx_save_state()
            fcitx_off()
          end,
        })

        vim.api.nvim_create_autocmd("InsertEnter", {
          callback = function()
            if fcitx5state == 2 then
              fcitx_on()
            end
          end,
        })
      end
    end
  }
}
