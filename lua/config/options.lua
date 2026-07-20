local opt = vim.opt

-- === Cơ bản (giữ từ config cũ) ===
opt.clipboard = "unnamedplus" -- Dùng chung clipboard với hệ thống
opt.number = true -- Hiện số dòng
opt.relativenumber = true -- Số dòng tương đối (dễ nhảy jk)
opt.cursorline = true -- Tô sáng dòng đang đứng
opt.confirm = true -- Hỏi lưu thay vì báo lỗi khi thoát buffer chưa lưu

-- Ẩn dấu ~ ở các dòng trống cuối buffer
opt.fillchars = { eob = " " }

-- === Thụt lề ===
opt.expandtab = true -- Tab chèn dấu cách thay vì ký tự tab
opt.shiftwidth = 2 -- 1 cấp thụt lề = 2 space
opt.tabstop = 2 -- 1 tab hiển thị rộng 2 space
opt.softtabstop = 2 -- Gõ/xoá Tab coi như 2 space
opt.smartindent = true -- Tự thụt lề theo cú pháp code
opt.shiftround = true -- >> làm tròn về bội số của shiftwidth

-- === Tìm kiếm ===
opt.ignorecase = true -- Không phân biệt hoa/thường
opt.smartcase = true -- ...trừ khi query có chữ hoa
opt.inccommand = "nosplit" -- Xem trước kết quả :%s/ khi đang gõ

-- === Giao diện / chỉnh sửa ===
opt.termguicolors = true -- Bật màu 24-bit cho colorscheme
opt.signcolumn = "yes" -- Luôn chừa cột dấu (tránh giật layout)
opt.scrolloff = 4 -- Chừa >=4 dòng trên/dưới con trỏ
opt.sidescrolloff = 8 -- Tương tự theo chiều ngang
opt.wrap = false -- Dòng dài không xuống hàng
opt.linebreak = true -- Nếu có wrap thì ngắt ở khoảng trắng
opt.virtualedit = "block" -- Cho phép đặt con trỏ ở vùng trống khi visual-block
opt.laststatus = 3 -- Một statusline duy nhất toàn màn hình
opt.pumheight = 10 -- Menu gợi ý tối đa 10 dòng
opt.pumblend = 10 -- Menu gợi ý hơi trong suốt

-- === Chia cửa sổ ===
opt.splitbelow = true -- Split ngang mở cửa sổ mới bên dưới
opt.splitright = true -- Split dọc mở cửa sổ mới bên phải
opt.splitkeep = "screen" -- Giữ nội dung không nhảy khi mở/đóng split

-- === Undo bền vững ===
opt.undofile = true -- Lưu lịch sử undo ra đĩa, còn sau khi đóng file
opt.undolevels = 10000 -- Số bước undo tối đa

-- === Phản hồi ===
opt.updatetime = 200 -- Kích hoạt event (hover, blame...) sau 200ms
opt.timeoutlen = 300 -- Thời gian chờ phím tiếp theo của tổ hợp (which-key)
