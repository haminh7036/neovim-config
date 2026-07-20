 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#1e1e2e',
    base01 = '#313244',
    base02 = '#3a3b50',
    base03 = '#646789',
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

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#cdd6f4',          bg = '#1e1e2e' })
  hi('TelescopeBorder',         { fg = '#646789',             bg = '#1e1e2e' })
  hi('TelescopePromptNormal',   { fg = '#cdd6f4',          bg = '#1e1e2e' })
  hi('TelescopePromptBorder',   { fg = '#646789',             bg = '#1e1e2e' })
  hi('TelescopePromptPrefix',   { fg = '#b4befe',             bg = '#1e1e2e' })
  hi('TelescopePromptCounter',  { fg = '#a3b4eb',  bg = '#1e1e2e' })
  hi('TelescopePromptTitle',    { fg = '#1e1e2e',             bg = '#b4befe' })
  hi('TelescopePreviewTitle',   { fg = '#1e1e2e',             bg = '#f5bde6' })
  hi('TelescopeResultsTitle',   { fg = '#1e1e2e',             bg = '#c6a0f6' })
  hi('TelescopeSelection',      { fg = '#cdd6f4',          bg = '#3a3b50' })
  hi('TelescopeSelectionCaret', { fg = '#b4befe',             bg = '#3a3b50' })
  hi('TelescopeMatching',       { fg = '#b4befe',             bold = true })

  -- Line number highlights (dim relative numbers, highlight cursor line number)
  hi('LineNr',                  { fg = '#45475a' })
  hi('LineNrAbove',             { fg = '#45475a' })
  hi('LineNrBelow',             { fg = '#45475a' })
  hi('CursorLineNr',            { fg = '#b4befe', bold = true })

  -- GitSigns highlight directly on line numbers
  hi('GitSignsAddNr',           { fg = '#a6e3a1', bold = true })
  hi('GitSignsChangeNr',        { fg = '#f9e2af', bold = true })
  hi('GitSignsDeleteNr',        { fg = '#f38ba8', bold = true })
end

 -- Register a signal handler for SIGUSR1 (matugen updates)
 local signal = vim.uv.new_signal()
 signal:start(
   'sigusr1',
   vim.schedule_wrap(function()
     package.loaded['matugen'] = nil
     require('matugen').setup()
   end)
 )

 return M
