-- Treesitter configuration for syntax highlighting

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "python", "lua", "vim", "vimdoc" },  -- Auto-install these parsers
      auto_install = true,  -- Auto-install parsers when entering new filetype
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,  -- Better indentation support
      },
    })
  end,
}
