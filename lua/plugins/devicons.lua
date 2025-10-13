-- nvim-web-devicons configuration
-- Custom icon overrides for file types and patterns

return {
  'nvim-tree/nvim-web-devicons',
  lazy = false,
  priority = 1000, -- Load early so other plugins can use it
  config = function()
    local devicons = require('nvim-web-devicons')

    -- Store the original get_icon function before setup
    local original_get_icon = devicons.get_icon

    -- Set up default devicons configuration
    devicons.setup({
      override = {},
      default = true,
    })

    -- Override get_icon to add custom logic for test files
    devicons.get_icon = function(name, ext, opts)
      -- Check if filename contains "test"
      if name and name:match('test') and ext == 'py' then
        -- Return beaker icon
        return '', 'DevIconPyTest'
      end

      -- Fall back to original behavior
      return original_get_icon(name, ext, opts)
    end

    -- Define highlight for test file icon (bright science green) with force to override
    vim.api.nvim_set_hl(0, 'DevIconPyTest', { fg = '#89F336', force = true })
  end,
}
