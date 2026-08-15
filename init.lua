-- Nạp options (các thiết lập hệ thống)
require("config.options")

-- Nạp keymaps (phím tắt chung)
require("config.keymaps")

-- Tự động nhận diện thư mục gốc dự án (Native vim.fs.root)
require("config.root")

-- Quản lý bộ gõ tiếng Việt Fcitx5 Native
require("config.fcitx5")

-- Thiết lập lazy.nvim & nạp plugin
require("config.lazy")

-- Cấu hình bảng màu Matugen
require("matugen").setup()
