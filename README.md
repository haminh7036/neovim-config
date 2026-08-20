# Neovim Configuration (v0.12+)

Bộ cấu hình Neovim tinh gọn, tập trung vào hiệu năng và trải nghiệm lập trình:
* **Native LSP & Completion**: Tận dụng API Native LSP của Neovim (v0.12+) kết hợp `blink.cmp`.
* **Bộ gõ Fcitx5**: Tích hợp điều khiển IME tiếng Việt trực tiếp qua Libuv process, tự động chuyển đổi theo chế độ và buffer.
* **Dynamic Theming**: Đồng bộ bảng màu hệ thống qua Matugen (`SIGUSR1`).
* **Root Detection**: Tự động nhận diện thư mục gốc của dự án (`vim.fs.root`).

---

## Yêu cầu hệ thống (Prerequisites)

* **Neovim >= 0.11.0** (khuyến nghị **v0.12+** cho Native LSP API).
* **Git** & **ripgrep** (cần cho tìm kiếm file và nội dung với `fzf-lua`).
* **Fcitx5** & **fcitx5-remote** (quản lý trạng thái bộ gõ tiếng Việt).
* **Matugen** (tùy chọn: đồng bộ theme theo hình nền hệ thống).
* **LazyGit** (tùy chọn: giao diện Git TUI).

---

## Cài đặt (Installation)

```bash
# 1. Sao lưu cấu hình cũ (nếu có)
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.state/nvim ~/.state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak

# 2. Clone repository vào thư mục config
git clone https://github.com/haminh7036/neovim-config.git ~/.config/nvim
```

> [!NOTE]
> Trong lần khởi động đầu tiên, `lazy.nvim` sẽ tự động tải và cài đặt các plugin được khai báo.

---

## Cấu trúc thư mục (Directory Structure)

```text
~/.config/nvim/
├── .stylua.toml        # Quy chuẩn định dạng code Lua (indent 2 spaces)
├── init.lua            # Entry point khởi tạo cấu hình
├── lazy-lock.json      # File lock quản lý phiên bản plugin
├── LICENSE             # Giấy phép mã nguồn
├── README.md           # Tài liệu hướng dẫn sử dụng
└── lua/
    ├── matugen.lua     # Module xử lý tín hiệu đổi theme từ Matugen
    ├── config/
    │   ├── autocmds.lua # Các autocommand hệ thống (Yank highlight, restore cursor...)
    │   ├── fcitx5.lua   # Điều khiển Fcitx5 qua Libuv process
    │   ├── keymaps.lua  # Phím tắt chung và floating terminal / LazyGit
    │   ├── lazy.lua     # Khởi tạo và thiết lập lazy.nvim
    │   ├── options.lua  # Thiết lập tùy chọn hệ thống (Vim options)
    │   └── root.lua     # Cơ chế nhận diện root directory dự án (vim.fs.root)
    └── plugins/
        ├── base16.lua           # Color scheme base16-nvim và Matugen loader
        ├── dial.lua             # Mở rộng tăng/giảm giá trị, boolean, case (dial.nvim)
        ├── grug-far.lua         # Tìm kiếm và thay thế toàn dự án (grug-far.nvim)
        ├── nvim-tree.lua        # Trình quản lý cây thư mục (File explorer)
        ├── which-key.lua        # Hiển thị gợi ý phím tắt (Which-Key)
        ├── treesitter.lua       # Phân tích cú pháp theo AST (Syntax highlighting)
        ├── blink.lua            # Engine autocomplete viết bằng Rust (blink.cmp)
        ├── lsp.lua              # Cấu hình Native LSP, Mason & SchemaStore
        ├── tiny-inline-diagnostic.lua # Hiển thị diagnostic inline (tiny-inline-diagnostic)
        ├── fzf.lua              # Tìm kiếm mờ (Fuzzy finder) file và văn bản
        ├── formatting.lua       # Tự động format mã nguồn khi lưu (Conform.nvim)
        ├── git.lua              # Git signs ở gutter và trình xem diff (Diffview)
        ├── image.lua            # Hiển thị hình ảnh (Kitty Graphics Protocol)
        ├── ui.lua               # Giao diện Statusline (lualine) & Tabline (bufferline)
        ├── session.lua          # Lưu và khôi phục session làm việc (Persistence)
        ├── neoscroll.lua        # Hiệu ứng cuộn mượt (Smooth scrolling)
        ├── indent-blankline.lua # Hiển thị đường gióng thụt đầu dòng (Indent guides)
        ├── nvim-surround.lua    # Thao tác với cặp ký tự bao quanh (Surround)
        ├── flash.lua            # Điều hướng nhanh tới vị trí hiển thị (Motion)
        ├── lazydev.lua          # Hỗ trợ autocomplete cho Neovim Lua API
        ├── todo-comments.lua    # Highlight và tìm kiếm comment TODO/FIX/NOTE
        ├── trouble.lua          # Danh sách hiển thị diagnostics, quickfix, references
        ├── mini-ai.lua          # Mở rộng text objects (tham số, hàm, block)
        └── utilities.lua        # Tự động đóng ngoặc (nvim-autopairs)
```

---

## Tính năng chính (Key Features)

### 1. Tích hợp bộ gõ Fcitx5
* **Hiệu năng cao**: Gọi trực tiếp binary `fcitx5-remote` thông qua API Libuv process (`vim.fn.system` dạng list arguments), không fork shell con. Thời gian phản hồi < 1ms khi rời Insert mode (`<Esc>`).
* **Buffer-local State**: Lưu trạng thái IME độc lập theo từng buffer; tự động khôi phục đúng chế độ khi chuyển đổi qua lại giữa các file.
* **Loại trừ Filetypes**: Tự động tắt IME trên các buffer tiện ích (`NvimTree`, `fzf`, `lazy`, `mason`...) để tránh xung đột phím tắt ở Normal mode.
* **Đồng bộ Focus**: Lưu và khôi phục trạng thái bộ gõ khi chuyển cửa sổ terminal (`FocusGained`/`FocusLost`) hoặc thoát editor.

### 2. Native LSP, SchemaStore & Completion
* **Native LSP API**: Sử dụng hoàn toàn cơ chế `vim.lsp.config` và `vim.lsp.enable` của Neovim v0.12+, không phụ thuộc wrapper cũ.
* **SchemaStore Integration**: Tự động nạp schema từ SchemaStore cho `jsonls` và `yamlls` (validate và autocomplete cho JSON Schema, GitHub Actions, Compose...).
* **Engine Completion**: Sử dụng `blink.cmp` (Rust-based) cho tốc độ index và render danh sách gợi ý nhanh, tiêu tốn ít tài nguyên.
* **Inline Diagnostics**: Tích hợp `tiny-inline-diagnostic.nvim` hiển thị chi tiết lỗi/cảnh báo ở cuối dòng gọn gàng, không làm xô lệch cấu trúc code.
* **Quản lý Package**: Tích hợp Mason để cài đặt, cập nhật LSP server, linter và formatter tập trung.

### 3. Tìm kiếm & Chỉnh sửa nâng cao
* **Search & Replace (`grug-far.nvim`)**: Tìm kiếm và thay thế trực quan trên toàn bộ dự án với `ripgrep`, hỗ trợ xem trước diff và lọc theo đường dẫn.
* **Tăng / Giảm thông minh (`dial.nvim`)**: Mở rộng `<C-a>` / `<C-x>` để toggle nhanh `true` / `false`, `&&` / `||`, `==` / `!=`, ngày tháng, semver và chuyển đổi naming convention (`camelCase` $\leftrightarrow$ `snake_case` $\leftrightarrow$ `PascalCase`).

### 4. Đồng bộ giao diện (Matugen Sync)
* Module `matugen.lua` bắt tín hiệu `SIGUSR1` từ daemon hệ thống. Khi hình nền hoặc palette màu hệ thống thay đổi, Neovim tự động nạp lại theme tương ứng trong thời gian thực.

### 5. Quản lý Session & Editor Motion
* **Session Management**: Tự động lưu buffer, layout cửa sổ và vị trí con trỏ theo thư mục dự án; cho phép khôi phục phiên làm việc trước đó.
* **Motion & Text Objects**: Tích hợp `flash.nvim` để nhảy vị trí bằng nhãn 2 ký tự, `mini.ai` để thao tác nhanh với text objects (tham số hàm, closure, tag XML/HTML).

### 6. Tự động nhận diện thư mục gốc (Project Root Detection)
* **Thuật toán tìm kiếm**: Sử dụng C-API `vim.fs.root` để quét ngược từ file hiện tại tới root pattern gần nhất (`composer.json`, `go.mod`, `package.json`, `pyproject.toml`, `Cargo.toml`, `CMakeLists.txt`, `Makefile`, hoặc `.git`).
* **Hỗ trợ Monorepo / Container**: Đảm bảo File Explorer và Fuzzy Finder bám đúng ngữ cảnh của source package khi làm việc trong sub-directory hoặc cấu trúc Docker.
* **Đồng bộ File Explorer**: `nvim-tree` tự động cập nhật thư mục gốc hiển thị theo project root hiện hành.

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
