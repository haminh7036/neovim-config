# Cấu hình Neovim

Cấu hình Neovim hiệu năng cao, hỗ trợ đầy đủ tính năng của một IDE hiện đại và đồng bộ màu sắc động theo hệ thống.

## Các tính năng chính

- **Quản lý plugin**: Sử dụng lazy.nvim.
- **Tự động chuyển đổi bộ gõ Fcitx5 (fcitx.nvim)**: Tự động tắt bộ gõ tiếng Việt khi rời `Insert Mode` để tránh lỗi phím tắt ở `Normal Mode`, tự động bật lại khi vào lại `Insert Mode`.
- **Hoàn thành mã siêu tốc (blink.cmp)**: Bộ gợi ý code (Autocomplete) thế hệ mới viết bằng Rust, phản hồi cực nhanh, tích hợp LSP và snippets.
- **Quản lý & Cấu hình LSP (LSPConfig + Mason)**: Tự động tải và cấu hình các máy chủ ngôn ngữ (LSP Servers), hỗ trợ chẩn đoán lỗi, định nghĩa code và đề xuất sửa lỗi nhanh.
- **Tìm kiếm thông minh (fzf-lua)**: Tìm kiếm file, từ khóa (grep), buffer với hiệu năng cực cao dựa trên nhân fzf.
- **Định dạng mã (conform.nvim)**: Định dạng code tự động khi lưu file (Format on save) một cách bất đồng bộ không gây giật lag.
- **Tô sáng cú pháp (nvim-treesitter)**: Tô sáng code thông minh dựa trên AST (Abstract Syntax Tree) chuẩn xác và nhanh hơn regex truyền thống.
- **Tích hợp Git (gitsigns.nvim)**: Hiển thị trạng thái thêm/sửa/xóa dòng trực tiếp ở lề trái (gutter) và thao tác nhanh với git hunks.
- **Giao diện IDE đẹp mắt (lualine & bufferline)**:
  - Thanh trạng thái chuyên nghiệp ở đáy màn hình.
  - Quản lý các file đang mở dưới dạng tab ở trên cùng.
- **Đồng bộ màu sắc động**: Tự động đồng bộ màu sắc giao diện theo hình nền hệ thống thông qua Matugen (lua/matugen.lua), kích hoạt bằng tín hiệu hệ thống `SIGUSR1`.
- **Cấu hình tiện ích**:
  - `nvim-autopairs`: Tự động đóng/mở ngoặc đơn, ngoặc nhọn, dấu nháy.
  - `Comment.nvim`: Comment nhanh code bằng phím tắt tiện lợi.

## Thiết lập mặc định

- Phím Leader: `Space` (Phím cách)
- Clipboard: `unnamedplus` (Dùng chung bộ nhớ tạm với hệ thống)
- Hiển thị số dòng tương đối (`relativenumber`) giúp nhảy dòng nhanh.
- Highlight dòng hiện tại (`cursorline`).
- Ẩn dấu `~` ở các dòng trống cuối buffer.

## Phím tắt chính

### Di chuyển & Giao diện
- `Leader + e`: Bật/tắt cây thư mục (`nvim-tree`).
- `Tab`: Chuyển sang file tiếp theo trong hàng đợi.
- `Shift + Tab`: Quay lại file trước đó trong hàng đợi.
- `Ctrl + h/j/k/l` hoặc `Ctrl + Phím mũi tên`: Di chuyển nhanh giữa các cửa sổ split.

### Tìm kiếm (FZF)
- `Leader + ff`: Tìm kiếm file nhanh trong dự án.
- `Leader + fg`: Tìm kiếm từ khóa (Live Grep) trong toàn bộ mã nguồn.
- `Leader + fb`: Xem và tìm kiếm các buffer đang mở.
- `Leader + fs`: Liệt kê và tìm các ký hiệu (symbols) trong file hiện tại.

### Lập trình & LSP
- `gd`: Đi tới định nghĩa hàm/biến (Go to Definition).
- `gD`: Đi tới khai báo (Go to Declaration).
- `gi`: Đi tới phần triển khai (Go to Implementation).
- `gr`: Liệt kê tất cả các vị trí sử dụng ký hiệu này (References).
- `K`: Xem tài liệu nhanh (Hover Documentation).
- `Leader + rn`: Đổi tên biến/hàm hàng loạt (Rename).
- `Leader + ca`: Xem các hành động sửa lỗi nhanh (Code Action).
- `[d` và `]d`: Nhảy tới lỗi trước đó/tiếp theo.
- `Leader + f`: Định dạng (format) file hiện tại theo chuẩn cấu hình.
- `gcc`: Comment dòng hiện tại (hoặc chọn nhiều dòng rồi gõ `gc`).

## Yêu cầu hệ thống

- Neovim >= 0.10.0 (khuyên dùng để tương thích tốt với blink.cmp)
- Git & Ripgrep (để fzf-lua tìm kiếm nội dung)
- Fcitx5 và fcitx5-remote (để tự chuyển bộ gõ)
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
├── README.md           # Hướng dẫn sử dụng này
└── lua/
    ├── matugen.lua     # Cấu hình màu sắc Matugen
    ├── config/
    │   ├── keymaps.lua # Cấu hình phím tắt chung
    │   ├── lazy.lua    # Thiết lập và bootstrap lazy.nvim
    │   └── options.lua # Các tùy chọn thiết lập hệ thống
    └── plugins/
        ├── colorscheme.lua # Khai báo plugin nvim-base16
        ├── nvim-tree.lua   # Khai báo và cấu hình nvim-tree.lua
        ├── which-key.lua   # Cấu hình gợi ý và nhắc phím tắt
        ├── fcitx5.lua      # Tự động switch bộ gõ tiếng Việt Fcitx5
        ├── treesitter.lua  # Highlight cú pháp ngữ nghĩa nâng cao
        ├── blink.lua       # Autocomplete siêu tốc viết bằng Rust
        ├── lsp.lua         # LSP config và Mason quản lý server
        ├── fzf.lua         # Fuzzy finder tìm kiếm file/code siêu nhanh
        ├── formatting.lua  # Cấu hình auto format code khi save
        ├── git.lua         # Tích hợp hiển thị thay đổi Git ở lề
        ├── ui.lua          # Thanh statusline (lualine) và tabs (bufferline)
        └── utilities.lua   # Tự động đóng ngoặc & comment nhanh
```
