-- DAP (Debug Adapter Protocol) configuration

return {
  -- Base DAP plugin
  {
    "mfussenegger/nvim-dap"
  },

  -- Python DAP adapter
  {
    "mfussenegger/nvim-dap-python",
    config = function()
      require("dap-python").setup("/home/wesleytaylor/.local/share/uv/tools/debugpy/bin/python")
      require('dap-python').test_runner = 'pytest'
    end,
  },

  -- DAP UI
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()  -- Initialize dapui before using it

      -- Automatically open/close DAP UI
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      -- DAP keybindings
      vim.keymap.set('n', '<leader>d<CR>', dap.continue, { desc = 'Start/Continue debugging' })
      vim.keymap.set('n', '<leader>d<BS>', dap.terminate, { desc = 'Terminate debugging' })
      vim.keymap.set('n', '<leader>d<Left>', dap.step_out, { desc = 'Step out' })
      vim.keymap.set('n', '<leader>d<Right>', dap.step_into, { desc = 'Step in' })
      vim.keymap.set('n', '<leader>d<Down>', dap.step_over, { desc = 'Step over' })
      vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'Continue' })
      vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Toggle breakpoint' })
      vim.keymap.set('n', '<leader>du', dapui.open, { desc = 'Open DAP UI' })
    end,
  }
}
