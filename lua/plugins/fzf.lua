return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader><space>", function() require("fzf-lua").files() end, desc = "Find Files" },
      { "<leader>/", function() require("fzf-lua").live_grep() end, desc = "Grep (Root Dir)" },
      { "<leader>,", function() require("fzf-lua").buffers() end, desc = "Switch Buffer" },
      { "<leader>ff", function() require("fzf-lua").files() end, desc = "Find Files" },
      { "<leader>fr", function() require("fzf-lua").oldfiles() end, desc = "Recent Files" },
      { "<leader>fb", function() require("fzf-lua").buffers() end, desc = "Buffers" },
      { "<leader>bb", function() require("fzf-lua").buffers() end, desc = "Switch Buffer" },
      { "<leader>sg", function() require("fzf-lua").live_grep() end, desc = "Live Grep" },
      { "<leader>sw", function() require("fzf-lua").grep_cword() end, desc = "Grep Word Under Cursor" },
      { "<leader>sb", function() require("fzf-lua").buffers() end, desc = "Search Buffers" },
      { "<leader>ss", function() require("fzf-lua").lsp_document_symbols() end, desc = "Document Symbols" },
      { "<leader>sh", function() require("fzf-lua").help_tags() end, desc = "Help Tags" },
      { "<leader>sk", function() require("fzf-lua").keymaps() end, desc = "Keymaps" },
    },
    opts = {
      winopts = {
        height = 0.85,
        width = 0.80,
        preview = {
          layout = "vertical",
        },
      },
      keymap = {
        builtin = {
          ["<c-d>"] = "preview-page-down",
          ["<c-u>"] = "preview-page-up",
        },
        fzf = {
          ["ctrl-d"] = "preview-page-down",
          ["ctrl-u"] = "preview-page-up",
        },
      },
    },
  },
}

