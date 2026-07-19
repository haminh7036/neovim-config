return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      local fzf = require("fzf-lua")
      fzf.setup({
        winopts = {
          height = 0.85,
          width = 0.80,
          preview = {
            layout = "vertical",
          },
        },
      })

      -- Keymaps
      -- Nhóm <leader>f: Find
      vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find Files" })
      vim.keymap.set("n", "<leader>fr", fzf.oldfiles, { desc = "Recent Files" })
      vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })

      -- Nhóm <leader>s: Search
      vim.keymap.set("n", "<leader>sg", fzf.live_grep, { desc = "Live Grep" })
      vim.keymap.set("n", "<leader>sw", fzf.grep_cword, { desc = "Grep Word Under Cursor" })
      vim.keymap.set("n", "<leader>sb", fzf.buffers, { desc = "Search Buffers" })
      vim.keymap.set("n", "<leader>ss", fzf.lsp_document_symbols, { desc = "Document Symbols" })
      vim.keymap.set("n", "<leader>sh", fzf.help_tags, { desc = "Help Tags" })
      vim.keymap.set("n", "<leader>sk", fzf.keymaps, { desc = "Keymaps" })
    end,
  }
}
