-- Autocommands

-- Enable Treesitter folding for Python files
vim.api.nvim_create_autocmd({'FileType'}, {
  pattern = 'python',
  callback = function()
    -- Use Treesitter for folding
    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo.foldenable = false  -- Start with all folds open
    vim.wo.foldlevel = 99      -- Open all folds initially
  end,
})

-- Function to toggle all docstrings
local function toggle_python_docstrings()
  -- Save cursor position
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  -- Find all docstring start lines
  local in_docstring = false
  local docstring_starts = {}

  for i, line in ipairs(lines) do
    if line:match('^%s*"""') or line:match("^%s*'''") then
      if not in_docstring then
        in_docstring = true
        table.insert(docstring_starts, i)
      else
        in_docstring = false
      end
    end
  end

  -- Check if any docstrings are open
  local any_open = false
  for _, line_num in ipairs(docstring_starts) do
    if vim.fn.foldclosed(line_num) == -1 then
      any_open = true
      break
    end
  end

  -- Toggle all docstring folds
  for _, line_num in ipairs(docstring_starts) do
    vim.api.nvim_win_set_cursor(0, {line_num, 0})
    if any_open then
      vim.cmd('silent! normal! zc')
    else
      vim.cmd('silent! normal! zo')
    end
  end

  -- Restore cursor position
  vim.api.nvim_win_set_cursor(0, cursor_pos)
end

-- Add keybinding for toggling docstrings in Python files
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    vim.keymap.set('n', '<leader>D', toggle_python_docstrings, {
      buffer = true,
      desc = 'Toggle all Python docstrings'
    })
  end,
})

-- Quickfix: close quickfix window after selecting an item
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function()
    vim.keymap.set('n', '<CR>', '<CR>:cclose<CR>', { buffer = true })
  end
})

-- Format on save functionality
-- Global variable to control format on save
vim.g.format_on_save = true  -- Default to enabled

-- Function to toggle format on save
local function toggle_format_on_save()
  vim.g.format_on_save = not vim.g.format_on_save
  local status = vim.g.format_on_save and "enabled" or "disabled"
  print("Format on save " .. status)
end

-- Function to save without formatting
local function save_without_format()
  vim.cmd('noautocmd write')
end

-- First, clear any existing BufWritePre autocommands for Python files
vim.api.nvim_create_augroup('PythonFormat', { clear = true })

-- Modified auto-format function that checks the global variable
vim.api.nvim_create_autocmd('BufWritePre', {
  group = 'PythonFormat',
  pattern = '*.py',
  callback = function()
    if vim.g.format_on_save then
      vim.lsp.buf.format({ timeout_ms = 1000 })
    end
  end,
})

-- Keybindings for format on save
vim.keymap.set('n', '<leader>tf', toggle_format_on_save, { desc = 'Toggle format on save' })
vim.keymap.set('n', '<leader>w', save_without_format, { desc = 'Save without formatting' })
vim.keymap.set('n', '<leader>fs', function()
  local status = vim.g.format_on_save and "enabled" or "disabled"
  print("Format on save is " .. status)
end, { desc = 'Show format on save status' })
