-- Barbar.nvim - tabline/buffer line plugin

return {
  'romgrk/barbar.nvim',
  dependencies = {
    'lewis6991/gitsigns.nvim',
    -- nvim-web-devicons loaded separately in plugins/devicons.lua
  },
  init = function()
    vim.g.barbar_auto_setup = false
  end,
  opts = {
    -- Basic configuration
    animation = true,
    auto_hide = false,
    tabpages = true,
    clickable = true,
  },
  config = function(_, opts)
    require('barbar').setup(opts)

    -- Keybindings for switching buffers
    vim.keymap.set('n', '<leader>t<Left>', '<Cmd>BufferPrevious<CR>', { desc = 'Go to previous buffer' })
    vim.keymap.set('n', '<leader>t<Right>', '<Cmd>BufferNext<CR>', { desc = 'Go to next buffer' })

    -- Close current buffer
    vim.keymap.set('n', '<leader>tq', '<Cmd>BufferClose<CR>', { desc = 'Close current buffer' })

    -- Keybindings for jumping to specific buffers
    vim.keymap.set('n', '<leader>t1', '<Cmd>BufferGoto 1<CR>', { desc = 'Go to buffer 1' })
    vim.keymap.set('n', '<leader>t2', '<Cmd>BufferGoto 2<CR>', { desc = 'Go to buffer 2' })
    vim.keymap.set('n', '<leader>t3', '<Cmd>BufferGoto 3<CR>', { desc = 'Go to buffer 3' })
    vim.keymap.set('n', '<leader>t4', '<Cmd>BufferGoto 4<CR>', { desc = 'Go to buffer 4' })
    vim.keymap.set('n', '<leader>t5', '<Cmd>BufferGoto 5<CR>', { desc = 'Go to buffer 5' })
    vim.keymap.set('n', '<leader>t6', '<Cmd>BufferGoto 6<CR>', { desc = 'Go to buffer 6' })
    vim.keymap.set('n', '<leader>t7', '<Cmd>BufferGoto 7<CR>', { desc = 'Go to buffer 7' })
    vim.keymap.set('n', '<leader>t8', '<Cmd>BufferGoto 8<CR>', { desc = 'Go to buffer 8' })
    vim.keymap.set('n', '<leader>t9', '<Cmd>BufferGoto 9<CR>', { desc = 'Go to buffer 9' })
  end,
}
