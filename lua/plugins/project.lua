return {
  -- Tự động nhận diện thư mục gốc của dự án bằng native vim.fs.root
  {
    "native-project-root",
    dir = vim.fn.stdpath("config"),
    lazy = false,
    config = function()
      local root_markers = {
        "composer.json",
        "artisan",
        "go.mod",
        "go.work",
        "package.json",
        "deno.json",
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
        "Cargo.toml",
        "CMakeLists.txt",
        "compile_commands.json",
        "Makefile",
        "configure.ac",
        "meson.build",
        ".git",
      }

      vim.api.nvim_create_autocmd({ "BufEnter", "BufReadPost" }, {
        group = vim.api.nvim_create_augroup("NativeProjectRoot", { clear = true }),
        callback = function(ctx)
          local path = vim.api.nvim_buf_get_name(ctx.buf)
          if path == "" or vim.bo[ctx.buf].buftype ~= "" then
            return
          end

          if path:match("^%a+://") or path:match("/%.cargo/") then
            return
          end

          local root = vim.fs.root(ctx.buf, root_markers)
          if root and root ~= "" and root ~= vim.fn.getcwd() then
            pcall(vim.fn.chdir, root)
          end
        end,
      })
    end,
  },
}
