return {
  -- project.nvim: tự động dò "thư mục gốc" của dự án theo file đang mở
  -- và chuyển cwd về đó, giúp nvim-tree + fzf-lua bám đúng codebase
  -- (đặc biệt hữu ích khi code nằm trong subdir của một dự án Docker).
  {
    "ahmedkhalf/project.nvim",
    -- Đặt tên module để require đúng (repo dùng "project_nvim")
    main = "project_nvim",
    -- Load ngay lúc khởi động: project.nvim đăng ký autocmd trên VimEnter để dò
    -- root cho buffer đầu tiên. Nếu lazy-load (VeryLazy) plugin sẽ load SAU VimEnter
    -- và bỏ lỡ file mở trực tiếp qua `nvim <file>`. Plugin nhẹ nên load sớm không đáng ngại.
    lazy = false,
    opts = {
      -- Auto mode: tự đổi root khi mở file (đặt true để tắt tự động, dùng :ProjectRoot)
      manual_mode = false,

      -- Chỉ dò theo marker (pattern). KHÔNG bật "lsp" vì repo gốc project.nvim
      -- gọi vim.lsp.buf_get_clients() — API đã bị gỡ ở Nvim 0.12 (bắn cảnh báo,
      -- và sẽ crash khi bị xóa hẳn). Root cho LSP thật do nvim-lspconfig lo riêng,
      -- còn danh sách marker dưới đây đã đủ để dò root cho mọi loại dự án.
      detection_methods = { "pattern" },

      -- Dò thư mục tổ tiên GẦN NHẤT chứa một trong các marker sau.
      -- Nhờ vậy marker của codebase (vd composer.json trong laravel/) luôn
      -- thắng .git nằm ở thư mục Docker bên ngoài.
      patterns = {
        -- Laravel / PHP
        "composer.json",
        "artisan",
        -- Go
        "go.mod",
        "go.work",
        -- Vue / JavaScript / TypeScript
        "package.json",
        "deno.json",
        -- Python
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
        -- Rust
        "Cargo.toml",
        -- C / C++
        "CMakeLists.txt",
        "compile_commands.json",
        "Makefile",
        "configure.ac",
        "meson.build",
        -- Fallback chung (đặt cuối: chỉ dùng khi không có marker nào gần hơn)
        ".git",
      },

      -- Đổi cwd toàn cục cho cả editor (khớp ngay với nvim-tree + fzf hiện tại)
      scope_chdir = "global",

      -- Không in thông báo mỗi lần đổi thư mục cho đỡ nhiễu
      silent_chdir = true,

      -- Không dò root cho các thư mục hệ thống
      exclude_dirs = { "~/.cargo/*" },

      -- Nơi lưu lịch sử project
      datapath = vim.fn.stdpath("data"),
    },
  },
}
