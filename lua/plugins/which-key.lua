return {
	-- Plugin gợi ý và nhắc phím tắt thông minh
	{
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
			-- Cấu hình hiển thị ở góc dưới bên phải và nhỏ gọn
			win = {
				no_overlap = true,
				width = 0.20, -- Chiều rộng 20% màn hình
				height = { min = 5, max = 30 }, -- Chiều cao từ 5 đến 30 dòng
				col = -1, -- Neo sát lề phải màn hình
				row = -1, -- Neo sát lề dưới màn hình
				border = "rounded", -- Viền bo tròn tinh tế
				padding = { 1, 1 }, -- Padding bên trong nhỏ gọn
			},
			layout = {
				width = { min = 50 }, -- Ép 1 cột dọc duy nhất
				spacing = 3,
			},
		},
		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)

			-- Đăng ký các nhóm phím tắt dưới phím Leader
			wk.add({
				{ "<leader>b", group = "Buffer" },
				{ "<leader>c", group = "Code" },
				{ "<leader>f", group = "Find" },
				{ "<leader>g", group = "Git" },
				{ "<leader>s", group = "Search" },
			})

			-- Đăng ký phím tắt Leader + ? để mở bảng tra cứu phím tắt nhanh
			vim.keymap.set("n", "<leader>?", function()
				wk.show()
			end, { desc = "Keymap Help" })
		end,
	},
}
