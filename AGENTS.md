# Project Rules & Custom Behaviors

Quy tắc riêng cho repo cấu hình Neovim này. Các quy tắc ở đây ưu tiên cao hơn hành vi mặc định của agent (kể cả các quy tắc ngôn ngữ chung ở cấp global — ví dụ nếu global bảo comment code bằng tiếng Anh, repo này vẫn giữ tiếng Việt, xem mục Code Style).

File này là bản chính (`AGENTS.md`, chuẩn dùng chung cho nhiều agent CLI: Claude Code, Codex, Cursor, Aider...). `.clinerules` và `CLAUDE.md` chỉ là symlink trỏ vào đây để từng tool tự nhận diện — sửa nội dung thì luôn sửa `AGENTS.md`, không sửa qua symlink.

## Tài liệu
- **[README Style]**: `README.md` viết bằng tiếng Việt, ngắn gọn, đơn giản, dễ đọc; không dùng emoji/icon; không xưng hô "bạn"/"tôi". Chỉ mô tả plugin/tính năng làm gì và cơ chế hoạt động ra sao, không dùng tính từ đánh giá/quảng cáo (siêu tốc, thông minh, mượt mà, trực quan, toàn diện, trải nghiệm...) — tham khảo văn phong tài liệu Go (`go.dev/doc`): nói sự thật/cơ chế, không nói nó tốt cỡ nào.
- **[README Sync]**: Cập nhật `README.md` (cấu trúc thư mục / mục tính năng / bảng phím tắt) là một phần bắt buộc của cùng lần thêm/sửa/xóa plugin hay tính năng — làm ngay trong lượt edit đó, không phải bước riêng làm sau hoặc chỉ khi được hỏi "có cần cập nhật docs không".

## Plugin
- **[Hiệu năng]**: Khi có nhiều plugin cùng chức năng, ưu tiên plugin hiệu năng cao viết bằng ngôn ngữ biên dịch (Rust, Go, C, C++) — ví dụ blink.cmp, fzf-lua. Chỉ chọn plugin thuần Lua/VimScript khi không có lựa chọn tương đương.
- **[Cấu trúc]**: Mỗi plugin nằm trong một file riêng dưới `lua/plugins/`, `return` một bảng spec lazy.nvim. Ưu tiên lazy-load qua `event`/`cmd`/`keys`; mọi keymap khai báo kèm `desc`.
- **[Lazy Lock]**: Thêm plugin bằng `Lazy! install` (chỉ cài plugin mới), tránh `Lazy! sync` vì nó bump commit của các plugin khác ngoài ý muốn. Giữ thay đổi trong `lazy-lock.json` tối thiểu — nếu lỡ chạy `sync`, kiểm tra `git diff lazy-lock.json` và loại bỏ mọi dòng bump ngoài ý muốn trước khi commit.

## Code Style
- **[Ngôn ngữ]**: Comment trong code Lua viết bằng tiếng Việt (ghi đè quy tắc "code comment tiếng Anh" ở cấp global — đây là chủ ý, không phải thiếu sót cần "sửa lại"). Giữ nguyên tên thuật ngữ kỹ thuật trong câu tiếng Việt (ví dụ: `capabilities`, `parser`, `keymaps`, `setup_handlers`, `buffer`, `Statusline`...), không dịch máy móc. Riêng chuỗi mô tả `desc = "..."` của keymap giữ tiếng Anh để đồng bộ với Neovim và các plugin. Thụt lề 2 spaces theo `.stylua.toml`.
- **[Văn phong Comment]**: Comment chỉ mô tả plugin/đoạn code đó làm gì và tại sao (cơ chế, lý do chọn), không dùng tính từ đánh giá/quảng cáo (siêu tốc, thông minh, mượt mà, gọn gàng, chuyên nghiệp, nhanh khi không cần thiết...) — cùng chuẩn với **[README Style]**.

## Git
- **[SSH]**: Ưu tiên SSH thay vì HTTPS khi push code để tránh bước nhập tài khoản/mật khẩu.
- **[Workflow]**: Không tự ý commit hoặc push. Chỉ commit/push khi có yêu cầu trực tiếp từ người dùng.

## Neovim
- **[Bootstrap]**: Luôn tích hợp bootstrap lazy.nvim để tự động tải plugin cần thiết nếu máy chạy Neovim chưa có sẵn.
