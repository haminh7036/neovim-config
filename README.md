# Cấu hình Neovim

Cấu hình Neovim tối giản hỗ trợ quản lý plugin và đồng bộ màu sắc động theo hệ thống.

## Các tính năng chính

- Quản lý plugin bằng lazy.nvim.
- Tự động đồng bộ màu sắc giao diện theo hình nền hệ thống thông qua Matugen (lua/matugen.lua), kích hoạt bằng tín hiệu hệ thống SIGUSR1.
- Sử dụng plugin nvim-base16 để thiết lập giao diện.
- Duyệt cây thư mục qua nvim-tree.lua.
- Các thiết lập mặc định:
  - Phím Leader: Space
  - Clipboard: unnamedplus (dùng chung với hệ thống)
  - Hiển thị số dòng tương đối (relativenumber)
  - Highlight dòng hiện tại (cursorline)
- Phím tắt mặc định:
  - Leader + e: Bật/tắt (toggle) cây thư mục
  - Thao tác trong cây thư mục:
    - Enter, o, l, Mũi tên Phải: Mở file hoặc thư mục
    - h, Mũi tên Trái: Đóng thư mục cha



## Yêu cầu hệ thống

- Neovim >= 0.9.0
- Git
- Matugen (để sử dụng tính năng đồng bộ màu sắc)

## Hướng dẫn cài đặt

Chạy các lệnh sau trong terminal:

```bash
# Sao lưu cấu hình cũ nếu có
mv ~/.config/nvim ~/.config/nvim.bak

# Clone cấu hình mới
git clone https://github.com/haminh7036/neovim-config.git ~/.config/nvim
```

Khi mở Neovim lần đầu tiên, lazy.nvim và các plugin đi kèm sẽ tự động cài đặt.

## Cấu trúc thư mục

```text
~/.config/nvim/
├── init.lua            # Điểm khởi chạy chính, tải các cấu hình trong lua/
├── lazy-lock.json      # File khóa phiên bản plugin
├── LICENSE             # Giấy phép mã nguồn
├── README.md           # Hướng dẫn sử dụng
└── lua/
    ├── matugen.lua     # Cấu hình màu sắc Matugen
    ├── config/
    │   ├── keymaps.lua # Cấu hình phím tắt chung
    │   ├── lazy.lua    # Thiết lập và bootstrap lazy.nvim
    │   └── options.lua # Các tùy chọn thiết lập hệ thống
    └── plugins/
        ├── colorscheme.lua # Khai báo plugin nvim-base16
        └── nvim-tree.lua   # Khai báo và cấu hình nvim-tree.lua
```
