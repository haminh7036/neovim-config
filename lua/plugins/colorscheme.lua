return {
  {
    "RRethy/nvim-base16",
    config = function()
      local ok, matugen = pcall(require, "matugen")
      if ok then
        matugen.setup()
      end
    end,
  },
}

