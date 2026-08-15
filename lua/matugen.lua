 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#1e1e2e',
    base01 = '#313244',
    base02 = '#3a3b50',
    base03 = '#646883',
    base04 = '#a3b4eb',
    base05 = '#cdd6f4',
    base06 = '#cdd6f4',
    base07 = '#cdd6f4',
    base08 = '#f38ba8',
    base09 = '#c6a0f6',
    base0A = '#f5bde6',
    base0B = '#b4befe',
    base0C = '#b98bf4',
    base0D = '#8192fd',
    base0E = '#ee90d5',
    base0F = '#c8043a',
  })
end

-- Register a signal handler for SIGUSR1 (matugen updates, Unix only)
if vim.fn.has("unix") == 1 then
  local signal = vim.uv.new_signal()
  if signal then
    pcall(function()
      signal:start(
        "sigusr1",
        vim.schedule_wrap(function()
          package.loaded["matugen"] = nil
          require("matugen").setup()
        end)
      )
    end)
  end
end

return M
