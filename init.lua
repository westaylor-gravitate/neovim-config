-- Neovim configuration entry point
-- This file loads all core settings and plugins from modular files

-- Load core configuration
require("core.options")   -- Vim options and settings
require("core.keymaps")   -- Global keymaps
require("core.autocmds")  -- Autocommands

-- Bootstrap lazy.nvim (plugin manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup plugins
require("lazy").setup("plugins")

-- Load LSP configuration (after plugins are loaded)
require("plugins.lsp")
