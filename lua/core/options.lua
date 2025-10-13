-- Basic Neovim settings
vim.g.mapleader = " "           -- Set leader key to space

vim.opt.number = true           -- Show line numbers
vim.opt.relativenumber = true   -- Show relative line numbers
vim.opt.expandtab = true        -- Use spaces instead of tabs
vim.opt.shiftwidth = 4          -- 4 spaces for indentation
vim.opt.tabstop = 4             -- 4 spaces for tab

-- Use terminal background instead of Neovim's default gray
vim.opt.termguicolors = true    -- Enable 24-bit colors for better highlighting
vim.cmd('highlight Normal ctermbg=NONE guibg=NONE')  -- Transparent background

-- Make floating windows (like hover docs) readable
vim.cmd('highlight NormalFloat guibg=#1e1e1e')  -- Dark background for floating windows
vim.cmd('highlight FloatBorder guifg=#565656')   -- Gray border for floating windows

-- Diagnostic configuration
vim.diagnostic.config({virtual_text=true})
