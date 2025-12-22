-- LSP configuration (Neovim 0.11+ native API)

-- Configure Ruff LSP (uses global uv tool)
vim.lsp.config.ruff = {
  cmd = { 'ruff', 'server', '--preview' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', 'setup.py', '.git' },
}

-- Configure basedpyright LSP
vim.lsp.config.basedpyright = {
  cmd = { 'basedpyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'setup.py', '.git' },
  settings = {
    basedpyright = {
      disableOrganizeImports = true, -- Let Ruff handle imports
      analysis = {
        typeCheckingMode = "basic",  -- or "strict" if you want more checking
        reportInvalidTypeForm = "none"
      }
    }
  }
}

-- Enable the LSP servers
vim.lsp.enable({ 'ruff', 'basedpyright' })

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
return {}
