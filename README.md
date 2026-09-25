# Neovim Configuration (v0.12+)

Cấu hình Neovim cá nhân, dùng Native LSP API và Go tooling:
* **Giao diện**: Catppuccin Mocha, chỉnh độ tương phản cho code, LSP diagnostics và nhãn `flash.nvim`.
* **LSP & Autocomplete**: Native LSP (Neovim 0.12+) kết hợp `blink.cmp` (engine gợi ý code viết bằng Rust).
* **Bộ gõ Fcitx5**: Tự động chuyển về tiếng Anh khi thoát Insert mode (`<Esc>`), ghi nhớ trạng thái theo từng buffer.
* **Tìm kiếm & Motion**: `fzf-lua`, `grug-far` (tìm/thay thế toàn dự án), `flash.nvim` (nhảy đến vị trí bằng nhãn ký tự).

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

# 4. Cài đặt toàn bộ công cụ Go (LSP, formatter, linter, debugger) qua Mason
#    Chạy 1 lần trên mỗi máy — binary không đi theo git, chỉ config mới sync.
nvim --headless -c "MasonInstall gopls delve golangci-lint goimports gofumpt" -c "qa"
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

## Tính năng chính

1. **Bộ gõ Fcitx5**:
   - Tự động chuyển về tiếng Anh khi thoát Insert mode, khôi phục lại tiếng Việt khi gõ tiếp.
   - Nhớ trạng thái IME độc lập cho từng buffer; tự tắt IME trên các cửa sổ tiện ích (`NvimTree`, `fzf`, `lazy`).

2. **Native LSP & Completion**:
   - Sử dụng hoàn toàn Native LSP API của Neovim 0.12+.
   - `blink.cmp`: Engine gợi ý code viết bằng Rust.
   - `tiny-inline-diagnostic`: Hiển thị thông báo lỗi cuối dòng, không thay đổi vị trí các dòng/cột khác.
   - `fidget.nvim`: Hiển thị tiến trình LSP (loading, indexing...) ở góc màn hình thay vì lẫn vào `:messages`.
   - Quản lý LSP server, linter và formatter tập trung qua `mason.nvim`.
   - Điều hướng (`gd`, `gi`, `gr`) qua `fzf-lua`: có preview code khi nhiều kết quả, thay vì quickfix list tĩnh.

3. **Giao diện Catppuccin Mocha**:
   - Bảng màu dark, áp dụng cho toàn bộ plugin (statusline, bufferline, diagnostics...).
   - Nhãn `flash.nvim` dùng màu tương phản cao so với nền.

4. **Tìm kiếm & Chỉnh sửa**:
   - **Tìm kiếm**: `fzf-lua` tìm file và grep bằng fuzzy finder; `grug-far` tìm & thay thế trên toàn dự án.
   - **Tự động lưu & đồng bộ**: Tự động lưu file khi chuyển buffer; tự reload khi file thay đổi từ bên ngoài (git pull, switch branch).
   - **Text Objects & Surround**: `mini.ai` mở rộng thao tác hàm/tham số; `nvim-surround` thêm/đổi/xóa nhanh dấu ngoặc.
   - **Thụt lề tự động**: `guess-indent.nvim` tự nhận diện tab/space và độ rộng theo từng file khi mở, tránh lệch convention giữa các dự án (Go dùng tab, PHP dùng 4-space...).
   - **Comment theo ngữ cảnh**: `ts-comments.nvim` xác định `commentstring` dựa trên vùng Treesitter chứa con trỏ, không theo filetype cố định của cả file — comment đúng cú pháp trong ngôn ngữ nhúng (vd. JS trong `<script>` của HTML).

5. **Debug (DAP) & Go Tooling**:
   - **`nvim-dap`** + **`nvim-dap-ui`**: Step debugger (breakpoint, step over/into/out, inspect biến, REPL).
   - **`nvim-dap-go`**: Tự cấu hình adapter Delve (`dlv`) cho Go, kèm lệnh debug nhanh 1 test case (`debug_test`/`debug_last_test`).
   - **`nvim-lint`**: Lint nền không block UI, dùng `golangci-lint` cho Go (bắt lỗi sâu hơn `go vet`: `errcheck`, `staticcheck`, `gosec`...).
   - **`conform.nvim`**: Format khi lưu file, Go dùng `goimports` (tự fix import) + `gofumpt` (format chặt hơn `gofmt` chuẩn).
   - Toàn bộ binary (`dlv`, `golangci-lint`, `goimports`, `gofumpt`, `gopls`) đều quản lý tập trung qua `mason.nvim` — không cần `go install` thủ công.

6. **Dashboard**:
   - `snacks.nvim`: Chỉ bật module `dashboard`, hiển thị màn hình chào khi mở Neovim ở thư mục (không chỉ định file).

---

## Bảng phím tắt (Keymaps Guide)

### 1. Điều hướng cửa sổ & Thao tác chung
| Phím tắt | Chức năng | Chế độ |
| :--- | :--- | :--- |
| `Ctrl + h / j / k / l` | Di chuyển focus sang cửa sổ Trái / Dưới / Trên / Phải | Normal |
| `Ctrl + Phím mũi tên` | Chỉnh kích thước cửa sổ (chiều cao/chiều rộng) | Normal |
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
| `Space + cL` | Lint buffer hiện tại (chạy tay, ngoài ra tự chạy khi lưu/rời Insert) | Normal |
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

### 6. Điều hướng bằng nhãn (Flash Motion)
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

### 8. Debug (DAP - Delve)
| Phím tắt | Chức năng | Chế độ |
| :--- | :--- | :--- |
| `F5` / `Space + dc` | Continue (chạy tới breakpoint kế tiếp, hoặc bắt đầu debug) | Normal |
| `F9` / `Space + db` | Toggle breakpoint tại dòng hiện tại | Normal |
| `Space + dB` | Đặt breakpoint có điều kiện (nhập expression) | Normal |
| `F10` / `Space + do` | Step Over | Normal |
| `F11` / `Space + di` | Step Into | Normal |
| `F12` / `Space + dO` | Step Out | Normal |
| `Space + dh` | Xem giá trị biến dưới con trỏ (Hover) | Normal |
| `Space + dr` | Bật / tắt REPL debug console | Normal |
| `Space + du` | Bật / tắt DAP UI (panel Scopes/Watches/Stacks) | Normal |
| `Space + dt` | Kết thúc phiên debug (Terminate) | Normal |
| `Space + dgt` | Debug test Go gần con trỏ nhất | Normal |
| `Space + dgl` | Debug lại test Go vừa chạy lần trước | Normal |

### 9. Tùy chọn hiển thị (UI Toggles)
| Phím tắt | Chức năng | Chế độ |
| :--- | :--- | :--- |
| `Space + uh` | Bật / tắt gợi ý kiểu dữ liệu (Inlay Hints) | Normal |
| `Space + ud` | Bật / tắt thông báo lỗi inline (Inline Diagnostics) | Normal |
| `Space + ub` | Bật / tắt Git blame dạng virtual text theo dòng | Normal |
