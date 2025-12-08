-- LSP configuration

-- Function to find ruff in virtual environment or system
local function find_ruff()
  -- Check if we're in a virtual environment
  local venv = os.getenv("VIRTUAL_ENV")
  if venv then
    local venv_ruff = venv .. "/bin/ruff"
    if vim.fn.executable(venv_ruff) == 1 then
      return venv_ruff
    end
  end

  -- Check common venv locations
  local possible_venvs = { "./venv/bin/ruff", "./.venv/bin/ruff", "./env/bin/ruff" }
  for _, path in ipairs(possible_venvs) do
    if vim.fn.executable(path) == 1 then
      return path
    end
  end

  -- Fall back to system ruff
  return "ruff"
end

-- Configure LSP servers
local lspconfig = require('lspconfig')

-- Configure Ruff LSP
lspconfig.ruff.setup({
  cmd = { find_ruff(), 'server', '--preview' },
  settings = {},  -- Ruff expects settings at top level, not nested
})

-- Configure basedpyright LSP
lspconfig.basedpyright.setup({
  settings = {
    basedpyright = {
      disableOrganizeImports = true, -- Let Ruff handle imports
      analysis = {
        typeCheckingMode = "basic",  -- or "strict" if you want more checking
        reportInvalidTypeForm = "none"
      }
    }
  }
})

-- LSP keybindings - this runs when any LSP attaches to a buffer
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    vim.lsp.completion.enable(true, args.data.client_id, args.buf)

    local opts = { buffer = args.buf }

    -- Useful keybindings (normal mode)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)         -- Go to definition
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)              -- Show docs under cursor
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts) -- Code actions (fixes)
    vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, opts)     -- Format current file
    vim.keymap.set('v', '<leader>f', vim.lsp.buf.format, opts)     -- Format selection
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)    -- Rename symbol
  end,
})

-- Global LSP keymaps
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Go to references' })

-- Return empty table since this file doesn't define a plugin spec
-- It just configures LSP using the nvim-lspconfig plugin defined in init.lua
return {}
