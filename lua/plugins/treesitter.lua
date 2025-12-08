-- Treesitter configuration for syntax highlighting

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
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
      textobjects = {
        select = {
          enable = true,
          lookahead = true,  -- Jump forward to textobj
          keymaps = {
            ["af"] = "@function.outer",  -- around function
            ["if"] = "@function.inner",  -- inside function
            ["ac"] = "@class.outer",     -- around class
            ["ic"] = "@class.inner",     -- inside class
          },
        },
      },
    })
  end,
}
