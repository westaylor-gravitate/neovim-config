-- Plugin specifications for lazy.nvim
-- Each plugin is configured in its own file in the plugins/ directory

return {
  -- LSP configuration
  { "neovim/nvim-lspconfig" },

  -- Colorscheme
  require("plugins.colorscheme"),

  -- Completion
  require("plugins.completion"),

  -- Treesitter for syntax highlighting
  require("plugins.treesitter"),

  -- Telescope fuzzy finder
  require("plugins.telescope"),

  -- Git integration
  require("plugins.git"),

  -- TypeScript tools
  require("plugins.typescript"),

  -- DAP (Debug Adapter Protocol)
  require("plugins.dap"),

  -- Barbar tabline
  require("plugins.barbar"),
}
