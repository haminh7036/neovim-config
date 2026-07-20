return {
  -- Bổ sung autocomplete & type-check cho Lua API của Neovim khi sửa config
  {
    "folke/lazydev.nvim",
    ft = "lua", -- Chỉ nạp khi mở file Lua
    cmd = "LazyDev",
    opts = {
      library = {
        -- Nạp type cho vim.uv khi trong code có nhắc tới
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
}
