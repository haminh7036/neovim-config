# Neovim Configuration (v0.12+)

Cấu hình Neovim hiện đại, tinh gọn, tập trung vào hiệu năng và trải nghiệm lập trình:
* **Giao diện**: Catppuccin Mocha, tối ưu độ tương phản cho code, LSP diagnostics và nhãn nhảy nhanh (`flash.nvim`).
* **LSP & Autocomplete**: Native LSP (Neovim 0.12+) kết hợp `blink.cmp` (Rust engine siêu tốc).
* **Bộ gõ Fcitx5**: Tự động chuyển về tiếng Anh khi thoát Insert mode (`<Esc>`), ghi nhớ trạng thái theo từng buffer.
* **Tìm kiếm & Motion**: `fzf-lua`, `grug-far` (tìm/thay thế toàn dự án), `flash.nvim` (nhảy nhanh con trỏ).

---

## Yêu cầu hệ thống (Prerequisites)

* **Neovim >= 0.11.0** (khuyến nghị **v0.12+**).
* **Git** & **ripgrep (`rg`)**: Phục vụ tìm kiếm file và nội dung.
* **Fcitx5** & **fcitx5-remote**: Quản lý trạng thái bộ gõ tiếng Việt (Linux).
* **LazyGit** *(tùy chọn)*: Giao diện Git TUI.

---

## Cài đặt (Installation)

```bash
# 1. Sao lưu cấu hình cũ (nếu có)
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak

# 2. Clone repository vào thư mục config
git clone https://github.com/haminh7036/neovim-config.git ~/.config/nvim

# 3. Khởi động Neovim (lazy.nvim sẽ tự động cài đặt plugin)
nvim
```

---

## Cấu trúc thư mục (Directory Structure)

```text
~/.config/nvim/
├── init.lua            # Điểm khởi đầu nạp cấu hình
├── lazy-lock.json      # Quản lý phiên bản plugin
└── lua/
    ├── config/
    │   ├── autocmds.lua # Tự động reload file, highlight yank, auto-save...
    │   ├── fcitx5.lua   # Điều khiển Fcitx5 qua Libuv
    │   ├── keymaps.lua  # Phím tắt chung, terminal, điều hướng cửa sổ
    │   ├── lazy.lua     # Khởi tạo và thiết lập lazy.nvim
    │   ├── options.lua  # Thiết lập Vim options (tab, indent, line number...)
    │   └── root.lua     # Tự động nhận diện thư mục gốc dự án
    └── plugins/         # Cấu hình từng plugin riêng biệt (LSP, UI, Git, Motion...)
```

---

## Tính năng nổi bật

1. **Bộ gõ Fcitx5 thông minh**:
   - Tự động chuyển về tiếng Anh khi thoát Insert mode, khôi phục lại tiếng Việt khi gõ tiếp.
   - Nhớ trạng thái IME độc lập cho từng buffer; tự tắt IME trên các cửa sổ tiện ích (`NvimTree`, `fzf`, `lazy`).

2. **Native LSP & Completion**:
   - Sử dụng hoàn toàn Native LSP API của Neovim 0.12+.
   - `blink.cmp`: Engine gợi ý code viết bằng Rust cho tốc độ tức thì và tiêu tốn ít RAM.
   - `tiny-inline-diagnostic`: Hiển thị thông báo lỗi cuối dòng gọn gàng, không làm xô lệch cấu trúc code.
   - Quản lý LSP server, linter và formatter tập trung qua `mason.nvim`.

3. **Giao diện Catppuccin Mocha**:
   - Bảng màu dark êm mắt, tích hợp sẵn và đồng bộ toàn diện với tất cả plugin.
   - Nhãn phím nhảy nhanh (`flash.nvim`) có độ tương phản cao, dễ nhìn.

4. **Tìm kiếm & Trải nghiệm soạn thảo**:
   - **Tìm kiếm**: `fzf-lua` tìm file và grep siêu nhanh; `grug-far` tìm & thay thế trực quan trên toàn dự án.
   - **Tự động lưu & đồng bộ**: Tự động lưu file khi chuyển buffer; tự reload khi file thay đổi từ bên ngoài (git pull, switch branch).
   - **Text Objects & Surround**: `mini.ai` mở rộng thao tác hàm/tham số; `nvim-surround` thêm/đổi/xóa nhanh dấu ngoặc.

---

## Bảng phím tắt (Keymaps Guide)

### 1. Điều hướng cửa sổ & Thao tác chung
| Phím tắt | Chức năng | Chế độ |
| :--- | :--- | :--- |
| `Ctrl + h / j / k / l` | Di chuyển focus sang cửa sổ Trái / Dưới / Trên / Phải | Normal |
| `Ctrl + Phím mũi tên` | Điều hướng nhanh giữa các split window | Normal |
| `Alt + j` | Di chuyển dòng / khối code được chọn xuống dưới | Normal / Insert / Visual |
| `Alt + k` | Di chuyển dòng / khối code được chọn lên trên | Normal / Insert / Visual |
| `Alt + Phím mũi tên Trái` | Nhảy lùi vị trí con trỏ trong jumplist | Normal |
| `Alt + Phím mũi tên Phải` | Nhảy tiến vị trí con trỏ trong jumplist | Normal |
| `Ctrl + s` | Lưu file hiện tại | Normal / Insert / Visual |
| `Esc` | Xóa highlight tìm kiếm và thoát Normal mode | Normal |
| `Ctrl + /` | Bật / tắt Floating Terminal | Normal / Terminal |
| `Ctrl + d` / `Ctrl + u` | Cuộn nửa trang và căn giữa con trỏ | Normal |
| `n` / `N` | Di chuyển đến kết quả tìm kiếm kế tiếp / trước đó (căn giữa) | Normal |
| `<` / `>` | Thụt lề trái / phải (giữ nguyên vùng chọn trong Visual mode) | Visual |
| `]q` / `[q` | Chuyển đến mục Quickfix List kế tiếp / trước đó | Normal |
| `Space + ?` | Mở bảng tra cứu phím tắt (Which-Key) | Normal |

### 2. Quản lý Buffer
| Phím tắt | Chức năng | Chế độ |
| :--- | :--- | :--- |
| `Tab` / `Shift + l` / `]b` | Chuyển đến buffer kế tiếp | Normal |
| `Shift + Tab` / `Shift + h` / `[b` | Chuyển đến buffer trước đó | Normal |
| `Space + ,` | Chuyển đổi nhanh buffer qua FZF | Normal |
| `Space + bd` | Đóng buffer hiện tại | Normal |
| `Space + bo` | Đóng tất cả các buffer khác | Normal |
| `Space + bp` | Ghim / Bỏ ghim buffer hiện tại (Toggle Pin) | Normal |
| `Space + bP` | Đóng toàn bộ buffer không được ghim | Normal |
| `Space + br` | Đóng toàn bộ buffer nằm bên phải buffer hiện tại | Normal |
| `Space + bl` | Đóng toàn bộ buffer nằm bên trái buffer hiện tại | Normal |
| `Space + b + 1..9` | Chuyển trực tiếp tới buffer theo số thứ tự (ví dụ: `<leader>b1`) | Normal |

### 3. Tìm kiếm & Thay thế (FZF-Lua & Grug-Far)
| Phím tắt | Chức năng | Chế độ |
| :--- | :--- | :--- |
| `Space + Space` | Tìm kiếm file trong toàn dự án | Normal |
| `Space + /` | Tìm kiếm nội dung văn bản (Live Grep) trong dự án | Normal |
| `Space + ff` | Tìm kiếm file theo thư mục làm việc | Normal |
| `Space + fr` | Mở danh sách file gần đây (Recent Files) | Normal |
| `Space + fb` | Danh sách buffer đang mở | Normal |
| `Space + ft` | Bật / tắt Floating Terminal | Normal |
| `Space + sg` | Tìm kiếm văn bản (Live Grep) | Normal |
| `Space + sw` | Tìm kiếm từ khóa dưới vị trí con trỏ (Grep Word) | Normal |
| `Space + sr` | Mở giao diện Search & Replace toàn dự án (`grug-far`) | Normal / Visual |
| `Space + sR` | Mở Search & Replace trong file hiện tại (`grug-far`) | Normal |
| `Space + ss` | Tìm kiếm symbol trong file hiện tại | Normal |
| `Space + sh` | Tra cứu tài liệu trợ giúp (Help Tags) | Normal |
| `Space + sk` | Tra cứu danh sách phím tắt | Normal |

### 4. LSP & Chỉnh sửa mã nguồn
| Phím tắt | Chức năng | Chế độ |
| :--- | :--- | :--- |
| `gd` | Nhảy đến định nghĩa (Go to Definition) | Normal |
| `gD` | Nhảy đến khai báo (Go to Declaration) | Normal |
| `gi` | Nhảy đến phần triển khai (Go to Implementation) | Normal |
| `gr` | Liệt kê danh sách tham chiếu (References) | Normal |
| `K` | Xem tài liệu hover của symbol dưới con trỏ | Normal |
| `Space + cr` | Đổi tên symbol trên toàn workspace (Rename) | Normal |
| `Space + ca` | Danh sách thao tác code nhanh (Code Action) | Normal |
| `Space + cd` | Hiển thị chi tiết diagnostic tại dòng hiện tại | Normal |
| `Space + cf` | Format mã nguồn file hiện tại | Normal |
| `[d` / `]d` | Chuyển đến diagnostic trước đó / kế tiếp | Normal |
| `gcc` | Bật / tắt comment dòng hiện tại | Normal |
| `gc` | Bật / tắt comment vùng chọn | Visual |
| `Ctrl + a` | Tăng số / toggle boolean (`true`/`false`) / cycle case (`dial`) | Normal / Visual |
| `Ctrl + x` | Giảm số / toggle boolean / cycle case (`dial`) | Normal / Visual |
| `ys` + motion + ký tự | Thêm cặp ký tự bao quanh (ví dụ: `ysiw"`) | Normal |
| `cs` + cũ + mới | Đổi cặp ký tự bao quanh (ví dụ: `cs"'`) | Normal |
| `ds` + ký tự | Xóa cặp ký tự bao quanh (ví dụ: `ds"`) | Normal |
| `cia` / `daa` | Thay đổi / xóa tham số hàm (`mini.ai`) | Normal |
| `cif` / `daf` | Thay đổi / xóa thân hàm (`mini.ai`) | Normal |
| `cit` / `dat` | Thao tác bên trong / toàn bộ cặp thẻ tag (`mini.ai`) | Normal |
| `p` | Dán đè lên vùng chọn mà không ghi đè clipboard | Visual |

### 5. Git & Session
| Phím tắt | Chức năng | Chế độ |
| :--- | :--- | :--- |
| `Space + e` | Bật / tắt File Explorer (`nvim-tree`) | Normal |
| `Space + gg` | Mở LazyGit floating window | Normal |
| `]c` / `[c` | Di chuyển đến Git Hunk kế tiếp / trước đó | Normal |
| `Space + gp` | Xem trước nội dung Git Hunk (Preview) | Normal |
| `Space + gb` | Xem thông tin Git Blame của dòng hiện tại | Normal |
| `Space + gs` | Stage / Unstage Git Hunk tại vị trí con trỏ | Normal |
| `Space + gr` | Revert (Reset) Git Hunk tại vị trí con trỏ | Normal |
| `Space + gD` | Mở Diffview toàn bộ dự án | Normal |
| `Space + gh` | Xem lịch sử commit của file (`DiffviewFileHistory`) | Normal |
| `Space + qs` | Khôi phục session của thư mục hiện tại | Normal |
| `Space + ql` | Khôi phục session gần nhất | Normal |
| `Space + qd` | Đóng phiên làm việc mà không lưu session | Normal |

### 6. Điều hướng nhanh (Flash Motion)
| Phím tắt | Chức năng | Chế độ |
| :--- | :--- | :--- |
| `s` + 2 ký tự | Hiển thị nhãn và nhảy trực tiếp đến vị trí đích (Flash) | Normal / Visual / Operator |
| `S` | Nhảy đến node cú pháp Treesitter | Normal / Operator |
| `r` | Remote Flash trong khi thực thi operator | Operator |
| `R` | Mở rộng vùng chọn theo AST Treesitter | Operator / Visual |

### 7. Diagnostics, Tasks & Trouble
| Phím tắt | Chức năng | Chế độ |
| :--- | :--- | :--- |
| `]t` / `[t` | Chuyển đến comment TODO kế tiếp / trước đó | Normal |
| `Space + st` | Tìm kiếm comment TODO qua FZF | Normal |
| `Space + xt` | Mở danh sách TODO trong panel Trouble | Normal |
| `Space + xx` | Mở toàn bộ Diagnostics trong Trouble | Normal |
| `Space + xX` | Mở Diagnostics của riêng buffer hiện tại | Normal |
| `Space + cs` | Mở cây Symbols trong Trouble | Normal |
| `Space + xl` | Mở Location List trong Trouble | Normal |
| `Space + xq` | Mở Quickfix List trong Trouble | Normal |

### 8. Tùy chọn hiển thị (UI Toggles)
| Phím tắt | Chức năng | Chế độ |
| :--- | :--- | :--- |
| `Space + uh` | Bật / tắt gợi ý kiểu dữ liệu (Inlay Hints) | Normal |
| `Space + ud` | Bật / tắt thông báo lỗi inline (Inline Diagnostics) | Normal |
