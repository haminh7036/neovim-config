return {
  -- Thanh trạng thái (Statusline)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        theme = "auto",
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        -- path = 1: hiện đường dẫn tương đối để phân biệt các file trùng tên (api/movies.go, data/movies.go)
        lualine_c = { { "filename", path = 1 } },
      },
    },
  },
  -- Bufferline (tab cho các buffer)
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      options = {
        numbers = "ordinal",
        diagnostics = "nvim_lsp",
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "left",
            separator = true,
          },
        },
      },
    },
  },
}
