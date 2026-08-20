return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "LspAttach",
  priority = 1000,
  opts = {
    preset = "modern",
    transparent_bg = true,
    options = {
      show_source = { enabled = true, if_many = true },
      use_icons_from_diagnostic = true,
      multilines = {
        enabled = true,
        always_show = false,
      },
      overflow = { mode = "wrap" },
      break_line = { enabled = true, after = 100 },
    },
  },
  keys = {
    {
      "<leader>ud",
      function()
        require("tiny-inline-diagnostic").toggle()
      end,
      desc = "Toggle Inline Diagnostics",
    },
  },
}
