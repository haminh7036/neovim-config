# Neovim Configuration (v0.12+)

Cấu hình Neovim hiệu năng cao, tối ưu cho lập trình viên hiện đại. Tự động đồng bộ màu sắc theo hệ thống (Matugen), hỗ trợ Native LSP thế hệ mới, Autocomplete siêu tốc (blink.cmp) và tích hợp bộ gõ tiếng Việt Fcitx5 thông minh không độ trễ.

---

## Yêu cầu hệ thống (Prerequisites)

Để cấu hình hoạt động hoàn hảo nhất, hệ thống cần cài đặt sẵn các công cụ sau:

*   **Neovim >= 0.11.0** (Khuyên dùng **v0.12.x** để hỗ trợ Native LSP config).
*   **Git** & **Ripgrep** (Cần thiết cho `fzf-lua` tìm kiếm file và nội dung nhanh).
*   **Fcitx5** & **fcitx5-remote** (Dùng cho tính năng tự động chuyển đổi bộ gõ).
*   **Matugen** (Để tự động đồng bộ màu sắc động theo hệ thống).
*   **LazyGit** (Để sử dụng trình quản lý Git UI tích hợp).

---

## Hướng dẫn cài đặt (Installation)

Chạy các lệnh sau trong terminal để cài đặt cấu hình:

```bash
# 1. Sao lưu cấu hình cũ nếu có
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.state/nvim ~/.state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak

# 2. Clone cấu hình mới về máy
git clone https://github.com/haminh7036/neovim-config.git ~/.config/nvim
```

> [!NOTE]
> Khi mở Neovim lần đầu tiên, trình quản lý `lazy.nvim` sẽ tự động tải xuống và cài đặt tất cả các plugin cần thiết.

---

## Cấu trúc thư mục (Directory Structure)

```text
~/.config/nvim/
├── .stylua.toml        # Cấu hình định dạng code Lua (2 spaces)
├── init.lua            # Điểm khởi chạy chính
├── lazy-lock.json      # File khóa phiên bản của các plugin
├── LICENSE             # Giấy phép mã nguồn
├── README.md           # Tài liệu hướng dẫn sử dụng này
└── lua/
    ├── matugen.lua     # Đồng bộ màu sắc hệ thống Matugen
    ├── config/
    │   ├── keymaps.lua # Cấu hình phím tắt chung của hệ thống
    │   ├── lazy.lua    # Thiết lập khởi chạy lazy.nvim
    │   └── options.lua # Các tùy chọn thiết lập hệ thống (options)
    └── plugins/
        ├── colorscheme.lua      # Khai báo plugin nvim-base16
        ├── nvim-tree.lua        # Cấu hình File Explorer (cây thư mục)
        ├── which-key.lua        # Nhắc phím tắt thông minh (Which-Key)
        ├── fcitx5.lua           # Tự động switch bộ gõ Fcitx5 Native Libuv
        ├── treesitter.lua       # Highlight cú pháp theo AST ngữ nghĩa
        ├── blink.lua            # Autocomplete thế hệ mới viết bằng Rust
        ├── lsp.lua              # Native LSP config & Mason package manager
        ├── fzf.lua              # Tìm kiếm file/code siêu nhanh bằng FZF
        ├── formatting.lua       # Cấu hình tự động format code khi lưu
        ├── git.lua              # Gitsigns hiển thị thay đổi trực tiếp ở lề
        ├── ui.lua               # Thanh Statusline (lualine) & Tabline (bufferline)
        ├── session.lua          # Tự động lưu và khôi phục phiên làm việc
        ├── lazygit.lua          # Tích hợp LazyGit UI trực tiếp vào editor
        ├── neoscroll.lua        # Hiệu ứng cuộn màn hình mượt mà
        ├── indent-blankline.lua # Hiển thị đường kẻ thụt lề (indent guides)
        ├── nvim-surround.lua    # Thêm/xóa/đổi cặp ký tự bao quanh (ys/ds/cs)
        ├── flash.lua            # Nhảy nhanh tới vị trí bất kỳ bằng nhãn ký tự
        ├── lazydev.lua          # Autocomplete Lua API của Neovim khi sửa config
        ├── todo-comments.lua    # Highlight & tìm comment TODO/FIX/HACK
        ├── trouble.lua          # Panel diagnostics / quickfix / references
        ├── mini-ai.lua          # Mở rộng text object a/i (tham số, lời gọi hàm)
        └── utilities.lua        # Tự động đóng ngoặc & comment nhanh
```

---

## Các nhóm tính năng nổi bật (Key Features)

### 1. Bộ gõ Tiếng Việt Fcitx5 Native
*   **Không độ trễ**: Sử dụng Native Libuv spawn (`vim.fn.system` truyền list) gọi trực tiếp binary `fcitx5-remote` không qua shell con. Tắt tiếng Việt chỉ mất dưới **1ms** ngay khi bấm `<Esc>`.
*   **Buffer-local**: Nhớ trạng thái bộ gõ của từng file riêng biệt. File này gõ tiếng Việt, file kia gõ tiếng Anh khi chuyển qua lại sẽ tự động chuyển đúng trạng thái.
*   **Ignore Filetypes**: Tự động bỏ qua và ép tắt tiếng Việt ở các cửa sổ đặc biệt như `NvimTree`, `Telescope`, `fzf`, `lazy`... để gõ phím tắt Normal mode không bao giờ bị dính preedit.
*   **Focus & System Sync**: Tự động trả lại bộ gõ tiếng Việt khi chuyển cửa sổ (Alt+Tab) ra ứng dụng khác và khôi phục bộ gõ gốc của hệ thống khi thoát Neovim.

### 2. Native LSP (v0.12+) & Autocomplete
*   **Không dùng API cũ**: Cấu hình sử dụng hoàn toàn cơ chế Native LSP hiện đại của Neovim (`vim.lsp.config` và `vim.lsp.enable`), loại bỏ hoàn toàn các framework cảnh báo deprecation cũ.
*   **Autocomplete siêu tốc**: Sử dụng `blink.cmp` viết bằng Rust, đem lại tốc độ gợi ý code vượt trội và mượt mà hơn hẳn so với `nvim-cmp`.
*   **Mason integration**: Quản lý và tự động tải các LSP servers một cách tập trung và dễ dàng thông qua giao diện Mason.

### 3. Đồng bộ màu sắc động (Matugen Sync)
*   Sử dụng module `matugen.lua` để lắng nghe tín hiệu hệ thống `SIGUSR1` từ daemon hình nền. Khi hình nền desktop thay đổi, giao diện Neovim sẽ tự động cập nhật bảng màu (color scheme) hài hòa theo ảnh nền thời gian thực.

### 4. Quản lý phiên làm việc & Trải nghiệm cuộn
*   **Persistence**: Tự động lưu phiên làm việc (các tab đang mở, vị trí con trỏ). Có thể khôi phục phiên làm việc trước đó hoặc phiên của thư mục hiện tại bất cứ lúc nào.
*   **Neoscroll**: Đem lại trải nghiệm cuộn màn hình (scroll) mượt mà bằng các chuyển động animation tự nhiên.

### 5. Tăng tốc di chuyển & chẩn đoán (LazyVim-inspired)
*   **Flash**: Nhấn `s` + 2 ký tự để hiện nhãn và nhảy tới bất kỳ vị trí nào trên màn hình, nhanh hơn nhiều so với tìm kiếm tuần tự.
*   **Trouble**: Gom toàn bộ lỗi LSP / quickfix / references vào một panel gọn, điều hướng nhanh giữa các mục.
*   **Todo Comments**: Tự động tô sáng và cho tìm nhanh các ghi chú `TODO`, `FIX`, `HACK`, `NOTE` trong dự án.
*   **Mini.ai**: Mở rộng text object `a`/`i` để thao tác theo cấu trúc — chọn tham số, lời gọi hàm, cặp ngoặc/nháy/tag một cách thông minh.
*   **LazyDev**: Bổ sung autocomplete và type-check cho Lua API của Neovim, cực tiện khi chỉnh sửa chính file cấu hình này.

### 6. Bộ tùy chọn editor tinh chỉnh (Options)
*   **Thụt lề nhất quán**: Mặc định 2 space (`expandtab`, `shiftwidth=2`), tự thụt lề theo cú pháp code.
*   **Tìm kiếm thông minh**: `smartcase` (chỉ phân biệt hoa/thường khi query có chữ hoa) và xem trước kết quả `:%s/` ngay khi gõ.
*   **Undo bền vững**: `undofile` lưu lịch sử undo ra đĩa — mở lại file ngày hôm sau vẫn hoàn tác được.
*   **Giao diện gọn**: Một statusline toàn cục (`laststatus=3`), cột dấu cố định tránh giật layout, luôn chừa 4 dòng đệm quanh con trỏ.

---

## Bảng phím tắt (Keymaps Guide)

### 1. Di chuyển, Điều hướng split & Thao tác chung
| Phím tắt | Chức năng | Chế độ |
| :--- | :--- | :--- |
| `Ctrl + h / j / k / l` | Di chuyển sang cửa sổ Trái / Dưới / Trên / Phải | Normal |
| `Ctrl + Phím mũi tên` | Di chuyển nhanh giữa các cửa sổ split tương ứng | Normal |
| `Alt + Phím mũi tên Trái` | Nhảy lùi con trỏ về vị trí trước đó (VSCode style) | Normal |
| `Alt + Phím mũi tên Phải` | Nhảy tiến con trỏ về vị trí tiếp theo (VSCode style) | Normal |
| `Ctrl + s` | Lưu file hiện tại | Normal / Insert / Visual |
| `Space + ?` | Mở bảng tra cứu toàn bộ phím tắt (Which-Key) | Normal |

### 2. Quản lý Buffers (Tab đang mở)
| Phím tắt | Chức năng | Chế độ |
| :--- | :--- | :--- |
| `Shift + h` hoặc `[b` | Chuyển sang buffer liền trước (Prev Buffer) | Normal |
| `Shift + l` hoặc `]b` | Chuyển sang buffer liền sau (Next Buffer) | Normal |
| `Space + ,` | Chuyển nhanh giữa các buffer qua FZF (LazyVim style) | Normal |
| `Space + bd` | Đóng buffer hiện tại | Normal |
| `Space + bo` | Đóng toàn bộ các buffer khác (Close Other Buffers) | Normal |
| `Space + bp` | Ghim / Bỏ ghim buffer hiện tại (Toggle Pin) | Normal |
| `Space + bP` | Đóng toàn bộ các buffer không được ghim | Normal |
| `Space + br` | Đóng toàn bộ các buffer nằm bên phải buffer hiện tại | Normal |
| `Space + bl` | Đóng toàn bộ các buffer nằm bên trái buffer hiện tại | Normal |

### 3. Tìm kiếm nhanh (FZF-Lua)
| Phím tắt | Chức năng | Chế độ |
| :--- | :--- | :--- |
| `Space + Space` | Tìm kiếm File nhanh trong toàn dự án (LazyVim style) | Normal |
| `Space + /` | Tìm kiếm từ khóa (Live Grep) trong dự án | Normal |
| `Space + ff` | Tìm kiếm File trong thư mục dự án | Normal |
| `Space + fr` | Danh sách các file mở gần đây (Recent Files) | Normal |
| `Space + fb` | Danh sách buffer đang hoạt động | Normal |
| `Space + sg` | Tìm kiếm từ khóa (Live Grep) | Normal |
| `Space + sw` | Tìm kiếm từ dưới con trỏ (Grep Word) | Normal |
| `Space + ss` | Tìm kiếm các ký hiệu (symbols) trong file hiện tại | Normal |
| `Space + sh` | Tìm kiếm trong tài liệu trợ giúp (Help Tags) | Normal |
| `Space + sk` | Xem danh sách toàn bộ phím tắt của Neovim | Normal |

### 4. Lập trình & LSP
| Phím tắt | Chức năng | Chế độ |
| :--- | :--- | :--- |
| `gd` | Đi tới định nghĩa hàm/biến (Go to Definition) | Normal |
| `gD` | Đi tới khai báo (Go to Declaration) | Normal |
| `gi` | Đi tới phần triển khai (Go to Implementation) | Normal |
| `gr` | Liệt kê tất cả các vị trí tham chiếu (References) | Normal |
| `K` | Xem tài liệu nhanh của ký hiệu dưới con trỏ (Hover) | Normal |
| `Space + cr` | Đổi tên biến/hàm hàng loạt (Rename) | Normal |
| `Space + ca` | Xem các hành động sửa lỗi nhanh (Code Action) | Normal |
| `Space + cf` | Định dạng lại code của file hiện tại (Format) | Normal |
| `[d` / `]d` | Di chuyển đến lỗi Diagnostic trước đó / tiếp theo | Normal |
| `gcc` | Bật/tắt comment dòng hiện tại | Normal |
| `gc` | Bật/tắt comment phần code đang bôi đen | Visual |
| `ys` + vùng + ký tự | Bọc vùng chọn bằng cặp ký tự, vd `ysiw"` (Surround) | Normal |
| `cs` + cũ + mới | Đổi cặp ký tự bao quanh, vd `cs"'` (Surround) | Normal |
| `ds` + ký tự | Xóa cặp ký tự bao quanh, vd `ds"` (Surround) | Normal |
| `cia` / `daa` | Sửa / xóa một tham số trong lời gọi hàm (mini.ai) | Normal |
| `cif` / `daf` | Sửa / xóa nội dung một lời gọi hàm (mini.ai) | Normal |
| `cit` / `dat` | Thao tác trong / cả cặp thẻ tag (mini.ai) | Normal |

### 5. Phiên làm việc & Git UI
| Phím tắt | Chức năng | Chế độ |
| :--- | :--- | :--- |
| `Space + e` | Bật/tắt cây thư mục File Explorer (`nvim-tree`) | Normal |
| `Space + gg` | Mở giao diện quản lý Git trực quan (`lazygit`) | Normal |
| `Space + qs` | Khôi phục lại phiên làm việc của thư mục hiện tại | Normal |
| `Space + ql` | Khôi phục phiên làm việc cuối cùng trước đó | Normal |
| `Space + qd` | Đặt trạng thái không lưu phiên làm việc hiện tại | Normal |

### 6. Nhảy nhanh trên màn hình (Flash)
| Phím tắt | Chức năng | Chế độ |
| :--- | :--- | :--- |
| `s` + 2 ký tự | Hiện nhãn và nhảy tới vị trí bất kỳ (Flash) | Normal / Visual / Operator |
| `S` | Nhảy tới theo node cú pháp Treesitter | Normal / Operator |
| `r` | Flash từ xa khi đang thao tác (Remote Flash) | Operator |
| `R` | Tìm và mở rộng lựa chọn theo Treesitter | Operator / Visual |

### 7. Chẩn đoán, Todo & Trouble
| Phím tắt | Chức năng | Chế độ |
| :--- | :--- | :--- |
| `]t` / `[t` | Nhảy tới comment Todo tiếp theo / trước đó | Normal |
| `Space + st` | Tìm kiếm toàn bộ comment Todo qua FZF | Normal |
| `Space + xt` | Mở danh sách Todo trong panel Trouble | Normal |
| `Space + xx` | Mở toàn bộ Diagnostics trong Trouble | Normal |
| `Space + xX` | Mở Diagnostics của riêng buffer hiện tại | Normal |
| `Space + cs` | Xem cây Symbols của file trong Trouble | Normal |
| `Space + xl` | Mở Location List trong Trouble | Normal |
| `Space + xq` | Mở Quickfix List trong Trouble | Normal |
