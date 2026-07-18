return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        -- Standard programming parsers
        ensure_installed = { 
          "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline",
          "javascript", "typescript", "html", "css", "json", "yaml", "bash", "python" 
        },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
      })
    end,
  }
}
