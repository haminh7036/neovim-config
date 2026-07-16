# Cấu hình Neovim Cá Nhân

Đây là kho lưu trữ cấu hình Neovim cá nhân, được tối ưu hóa cho trải nghiệm gõ code nhanh và khả năng đồng bộ màu sắc động theo hệ thống.

## 🚀 Các Tính Năng Chính

- **Quản lý Plugin**: Sử dụng [lazy.nvim](https://github.com/folke/lazy.nvim) - trình quản lý plugin hiện đại, nhanh và tối ưu hiệu năng.
- **Tự động đổi màu sắc (Dynamic Themes) qua Matugen**: Tích hợp cấu hình `lua/matugen.lua` để đồng bộ màu sắc giao diện Neovim theo hình nền máy tính (Material You) bằng cách bắt tín hiệu hệ thống `SIGUSR1`.
- **Giao diện**: Sử dụng plugin [nvim-base16](https://github.com/RRethy/nvim-base16) để thiết lập highlight đồng bộ cho các thành phần như Telescope.
- **Tiện ích hệ thống cấu hình sẵn**:
  - Phím **Leader** được gán cho phím cách (`Space`).
  - Chia sẻ **Clipboard** trực tiếp với hệ điều hành (`unnamedplus`).
  - Bật hiển thị số dòng tương đối (`relativenumber`) giúp di chuyển nhanh bằng phím bấm.
  - Tự động highlight dòng hiện tại (`cursorline`).

---

## 🛠️ Yêu cầu hệ thống

- **Neovim** phiên bản >= 0.9.0.
- **Git** (để tự động tải plugin).
- **Matugen** (nếu bạn muốn sử dụng tính năng đồng bộ màu theo hình nền).

---

## ⚙️ Hướng dẫn cài đặt

Để cài đặt cấu hình này, hãy chạy lệnh sau trong terminal của bạn:

```bash
# Sao lưu cấu hình cũ (nếu có)
mv ~/.config/nvim ~/.config/nvim.bak

# Clone repository này về thư mục cấu hình của Neovim
git clone https://github.com/haminh7036/neovim-config.git ~/.config/nvim
```

Khi bạn mở Neovim lần đầu tiên, trình quản lý plugin `lazy.nvim` và plugin `nvim-base16` sẽ tự động được tải xuống và cài đặt.

---

## 📂 Cấu trúc thư mục

```text
~/.config/nvim/
├── init.lua          # File cấu hình khởi chạy chính (Bootstrap lazy.nvim, options...)
├── lazy-lock.json    # File khóa phiên bản plugin (tự động cập nhật bởi lazy.nvim)
├── LICENSE           # Giấy phép mã nguồn mở
├── README.md         # Tài liệu hướng dẫn sử dụng (Tiếng Việt)
└── lua/
    └── matugen.lua   # Cấu hình bảng màu tích hợp với Matugen CLI
```
