-- Global keymaps that aren't plugin-specific
-- Plugin-specific keymaps are defined in their respective plugin config files

-- Window navigation (for splits)
vim.keymap.set('n', '<leader>b<Left>', '<C-w>h', { desc = 'Move to left split' })
vim.keymap.set('n', '<leader>b<Down>', '<C-w>j', { desc = 'Move to split below' })
vim.keymap.set('n', '<leader>b<Up>', '<C-w>k', { desc = 'Move to split above' })
vim.keymap.set('n', '<leader>b<Right>', '<C-w>l', { desc = 'Move to right split' })
vim.keymap.set('n', '<leader>bh', '<C-w>h', { desc = 'Move to left split' })
vim.keymap.set('n', '<leader>bj', '<C-w>j', { desc = 'Move to split below' })
vim.keymap.set('n', '<leader>bk', '<C-w>k', { desc = 'Move to split above' })
vim.keymap.set('n', '<leader>bl', '<C-w>l', { desc = 'Move to right split' })
