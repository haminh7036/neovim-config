return {
  -- Plugin duyệt cây thư mục (File Explorer)
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      -- Cấu hình phím tắt cho nvim-tree
      local function my_on_attach(bufnr)
        local api = require("nvim-tree.api")

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- Tải các phím tắt mặc định của nvim-tree
        api.config.mappings.default_on_attach(bufnr)

        -- Đọc thư mục gốc động: project.nvim có thể đổi cwd trong lúc chạy,
        -- nên phải lấy tại thời điểm gọi thay vì chụp một lần lúc attach.
        local function get_root()
          return vim.fn.getcwd()
        end

        -- Hàm mở an toàn, chặn không cho lùi ra ngoài khi nhấn phím mở ở thư mục gốc
        local function safe_open()
          local node = api.tree.get_node_under_cursor()
          if not node then return end

          -- Nếu đang đứng ở dòng đường dẫn gốc của dự án, chặn không cho thực hiện (tránh nvim-tree lùi ra cha)
          if node.absolute_path == get_root() then
            return
          end

          api.node.open.edit()
        end

        -- Hàm đóng thư mục an toàn, tuyệt đối không cho phép vượt qua thư mục gốc dự án (CWD)
        local function safe_close_parent()
          local node = api.tree.get_node_under_cursor()
          if not node then return end

          -- Nếu con trỏ đang ở chính thư mục gốc dự án, chặn không cho lùi tiếp
          if node.absolute_path == get_root() then
            return
          end

          -- Nếu node là thư mục và đang mở, đóng nó lại
          if node.type == "directory" and node.open then
            api.node.open.edit()
            return
          end

          -- Nếu node đã đóng (hoặc là file), di chuyển lên cha của nó
          local parent = node.parent
          if parent then
            -- Nếu thư mục cha chính là thư mục gốc dự án, chỉ di chuyển lên chứ không đóng (tránh đổi root)
            if parent.absolute_path == get_root() then
              api.node.navigate.parent()
              return
            end

            -- Các trường hợp thư mục cha nằm trong dự án thì đóng bình thường
            api.node.navigate.parent_close()
          end
        end

        -- Các phím tắt tùy chỉnh để điều hướng nhanh
        vim.keymap.set("n", "<CR>", safe_open, opts("Open (Safe)"))
        vim.keymap.set("n", "o", safe_open, opts("Open (Safe)"))
        vim.keymap.set("n", "l", safe_open, opts("Open (Safe)"))
        vim.keymap.set("n", "<Right>", safe_open, opts("Open (Safe)"))
        vim.keymap.set("n", "h", safe_close_parent, opts("Close Directory (Safe)"))
        vim.keymap.set("n", "<Left>", safe_close_parent, opts("Close Directory (Safe)"))
      end

      require("nvim-tree").setup({
        on_attach = my_on_attach,
        -- Đồng bộ root của cây theo cwd (project.nvim sẽ đổi cwd theo dự án),
        -- và tự cập nhật root/highlight theo file đang mở.
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = true,
        },
        sort = {
          sorter = "case_sensitive",
        },
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
          root_folder_label = false, -- Ẩn hoàn toàn dòng hiển thị thư mục gốc trên cùng để UI gọn gàng
        },
        git = {
          enable = true,
          ignore = true, -- Tự động ẩn các file/thư mục có trong .gitignore
        },
        filters = {
          dotfiles = true, -- Ẩn các file/thư mục ẩn bắt đầu bằng dấu chấm (ví dụ: .git, .gitignore)
        },
      })

      -- Cấu hình phím tắt Leader + e để tắt/mở cây thư mục
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle Explorer" })
    end,
  },
}
