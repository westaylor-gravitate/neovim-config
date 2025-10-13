-- Moonfly colorscheme configuration

return {
  "bluz71/vim-moonfly-colors",
  name = "moonfly",
  lazy = false,
  priority = 1000,
  config = function()
    vim.g.moonflyTransparent = true  -- Keep transparent background
    vim.cmd([[colorscheme moonfly]])
  end,
}
