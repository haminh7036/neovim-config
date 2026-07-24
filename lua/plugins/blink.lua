return {
  {
    "Saghen/blink.cmp",
    lazy = false, -- Nạp sớm để có autocomplete
    dependencies = "rafamadriz/friendly-snippets",
    version = "v0.*",
    opts = {
      keymap = { 
        preset = "default",
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-y>"] = { "select_and_accept" },
      },
      completion = {
        list = {
          selection = {
            preselect = function(ctx)
              return ctx.mode ~= "cmdline"
            end,
            auto_insert = true,
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
      },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },
}
