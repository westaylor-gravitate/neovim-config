-- Treesitter: parser management + textobjects
-- Neovim 0.12+ handles highlighting and indentation natively.

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
      end,
    })

    require("nvim-treesitter-textobjects").setup({
      select = { lookahead = true },
    })

    local select = require("nvim-treesitter-textobjects.select")
    local maps = {
      ["af"] = "@function.outer",
      ["if"] = "@function.inner",
      ["ac"] = "@class.outer",
      ["ic"] = "@class.inner",
    }
    for key, query in pairs(maps) do
      vim.keymap.set({ "x", "o" }, key, function()
        select.select_textobject(query)
      end)
    end
  end,
}
