return {
  {
    "3rd/image.nvim",
    build = false,
    ft = { "markdown", "vimwiki" },
    opts = {
      -- ponytail: relies on 3rd/image.nvim defaults (kitty backend + magick_cli processor)
      -- upgrade path: set window_overlap_clear_enabled = true if float popups (cmp/lsp) show image artifacts
    },
  },
}

