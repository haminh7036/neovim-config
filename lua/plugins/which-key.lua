-- Plugin gợi ý và nhắc phím tắt thông minh
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    -- Lọc bỏ các gợi ý liên quan đến thao tác chuột (Mouse, Scroll...)
    filter = function(mapping)
      local lhs = mapping.lhs:lower()
      if lhs:find("mouse") or lhs:find("scroll") then
        return false
      end
      return true
    end,
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    -- Hàm sinh danh sách phím số tương ứng các buffer đang mở với tên file thực tế
    local function expand_buffers()
      local ret = {}
      local ok, state = pcall(require, "bufferline.state")
      local components = ok and state.components or {}

      if #components > 0 then
        for i, item in ipairs(components) do
          if i <= 9 then
            table.insert(ret, {
              tostring(i),
              function()
                require("bufferline").go_to(i, true)
              end,
              desc = item.name or ("Buffer " .. i),
              icon = { cat = "file", name = item.name },
            })
          end
        end
      else
        local bufs = vim.tbl_filter(function(b)
          return vim.api.nvim_buf_is_loaded(b) and vim.bo[b].buftype == ""
        end, vim.api.nvim_list_bufs())
        for i, buf in ipairs(bufs) do
          if i <= 9 then
            local name = vim.api.nvim_buf_get_name(buf)
            local filename = name ~= "" and vim.fn.fnamemodify(name, ":t") or "[No Name]"
            table.insert(ret, {
              tostring(i),
              function()
                vim.api.nvim_set_current_buf(buf)
              end,
              desc = filename,
              icon = { cat = "file", name = filename },
            })
          end
        end
      end
      return ret
    end

    -- Đăng ký các nhóm phím tắt dưới phím Leader
    wk.add({
      { "<leader>b", group = "Buffer", expand = expand_buffers },
      { "<leader>c", group = "Code" },
      { "<leader>f", group = "Find" },
      { "<leader>g", group = "Git" },
      { "<leader>q", group = "Session/Quit" },
      { "<leader>s", group = "Search" },
      { "<leader>u", group = "UI/Toggle" },
      { "<leader>x", group = "Diagnostics/Quickfix" },
    })

    -- Đăng ký phím tắt Leader + ? để mở bảng tra cứu phím tắt nhanh
    vim.keymap.set("n", "<leader>?", function()
      wk.show()
    end, { desc = "Keymap Help" })
  end,
}
