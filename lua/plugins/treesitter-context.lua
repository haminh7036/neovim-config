return {
  -- Ghim dòng khai báo function/if/for/class... ở đầu cửa sổ khi cuộn xuống sâu bên trong
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      max_lines = 3,
      min_window_height = 20,
    },
    keys = {
      { "<leader>uc", "<cmd>TSContextToggle<cr>", desc = "Toggle Treesitter Context" },
    },
  },
}
