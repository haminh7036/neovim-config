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
      vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "FZF: Find Files" })
      vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "FZF: Live Grep (Search Text)" })
      vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "FZF: Find Buffers" })
      vim.keymap.set("n", "<leader>fh", fzf.help_tags, { desc = "FZF: Help Tags" })
      vim.keymap.set("n", "<leader>fs", fzf.lsp_document_symbols, { desc = "FZF: Document Symbols" })
    end,
  }
}
