-- Basic Neovim settings
vim.opt.number = true           -- Show line numbers
vim.opt.expandtab = true        -- Use spaces instead of tabs
vim.opt.shiftwidth = 4          -- 4 spaces for indentation
vim.opt.tabstop = 4             -- 4 spaces for tab
vim.g.mapleader = " "           -- Set leader key to space

-- Use terminal background instead of Neovim's default gray
vim.opt.termguicolors = true    -- Enable 24-bit colors for better highlighting
vim.cmd('highlight Normal ctermbg=NONE guibg=NONE')  -- Transparent background

-- Make floating windows (like hover docs) readable
vim.cmd('highlight NormalFloat guibg=#1e1e1e')  -- Dark background for floating windows
vim.cmd('highlight FloatBorder guifg=#565656')   -- Gray border for floating windows

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
require("lazy").setup({
  -- neovim LSP stuff
  { "neovim/nvim-lspconfig", },
  -- Colorscheme for better syntax colors
  { 
    "bluz71/vim-moonfly-colors", 
    name = "moonfly", 
    lazy = false, 
    priority = 1000,
    config = function()
      vim.g.moonflyTransparent = true  -- Keep transparent background
      vim.cmd([[colorscheme moonfly]])
    end,
  },
    {
    "nvim-telescope/telescope.nvim", tag="0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" }
    },
{
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local cmp = require('cmp')
    cmp.setup({
      mapping = {
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        ['<C-Space>'] = cmp.mapping.complete(),
      },
      sources = {
        { name = 'nvim_lsp' },
      },
      performance = {
        max_view_entries=10,
      },
      window = {
        documentation = {
          max_height = 10,
        },
        completion = {
          scrollbar = true,
        }
      },
      sorting = {
        priority_weight = 2,
        comparators = {
          -- Custom comparator for underscore and type priority
          function(entry1, entry2)
            local kind1 = entry1:get_kind()
            local kind2 = entry2:get_kind()
            local name1 = entry1.completion_item.label
            local name2 = entry2.completion_item.label
            
            local cmp_types = require('cmp.types')
            
            -- Check if names start with underscore
            local underscore1 = name1:match("^_") and true or false
            local underscore2 = name2:match("^_") and true or false
            
            -- If one has underscore and other doesn't, prioritize non-underscore
            if underscore1 ~= underscore2 then
              return not underscore1  -- non-underscore wins
            end
            
            -- If both have same underscore status, sort by type priority
            local type_priority = {
              [cmp_types.lsp.CompletionItemKind.Variable] = 1,
              [cmp_types.lsp.CompletionItemKind.Field] = 1,
              [cmp_types.lsp.CompletionItemKind.Property] = 2,
              [cmp_types.lsp.CompletionItemKind.Method] = 3,
              [cmp_types.lsp.CompletionItemKind.Function] = 3,
            }
            
            local p1 = type_priority[kind1] or 999
            local p2 = type_priority[kind2] or 999
            
            if p1 ~= p2 then
              return p1 < p2
            end
            
            -- If same type priority, sort alphabetically
            return name1 < name2
          end,
          
          -- Keep some default comparators but remove conflicting ones
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          cmp.config.compare.recently_used,
        },
      },
    })
  end,
},
  -- Treesitter for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "python", "lua", "vim", "vimdoc" },  -- Auto-install these parsers
        auto_install = true,  -- Auto-install parsers when entering new filetype
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,  -- Better indentation support
        },
      })
    end,
  },
  {
    "f-person/git-blame.nvim",
    -- load the plugin at startup
    event = "VeryLazy",
    -- Because of the keys part, you will be lazy loading this plugin.
    -- The plugin will only load once one of the keys is used.
    -- If you want to load the plugin at startup, add something like event = "VeryLazy",
    -- or lazy = false. One of both options will work.
    opts = {
        -- your configuration comes here
        -- for example
        enabled = true,  -- if you want to enable the plugin
        message_template = " <summary> • <date> • <author> • <<sha>>", -- template for the blame message, check the Message template section for more options
        date_format = "%m-%d-%Y %H:%M:%S", -- template for the date, check Date format section for more options
        virtual_text_column = 1,  -- virtual text start column, check Start virtual text at column section for more options
    },
 
},  
    {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  opts = {},
},
    {
        "mfussenegger/nvim-dap"
    },
    {
        "mfussenegger/nvim-dap-python",
        config = function()
            require("dap-python").setup("/home/wesleytaylor/.pyenv/versions/3.11.13/envs/debugger/bin/python")
            require('dap-python').test_runner = 'pytest'
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
        config = function()
            local dap, dapui = require("dap"), require("dapui")
            dapui.setup()  -- Initialize dapui before using it
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
})

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

-- Configure LSP servers using nvim-lspconfig
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
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)    -- Rename symbol
  end,
})


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

vim.diagnostic.config({virtual_text=true})

local builtin_tele = require('telescope.builtin')
-- vim.keymap.set('n', '<leader>ff', builtin_tele.find_files, { desc = 'Telescope find files' })

require('telescope').setup({
    defaults={
        file_ignore_patterns = {
            "%.pyc$",
            "__pycache__/",
        }
    }
})

local function calculate_path_distance(path1, path2)
  local parts1 = vim.split(path1, '/')
  local parts2 = vim.split(path2, '/')
  
  local common = 0
  for i = 1, math.min(#parts1, #parts2) do
    if parts1[i] == parts2[i] then
      common = common + 1
    else
      break
    end
  end
  
  return (#parts1 - common) + (#parts2 - common)
end

local function find_files_by_proximity()
  local current_file = vim.fn.expand('%:p')
  
  require('telescope.builtin').find_files({
    file_ignore_patterns = {"%.pyc$", "__pycache__/"},
    sorter = require('telescope.sorters').get_fzy_sorter({
      scoring_function = function(self, prompt, line)
        local fzy_score = require('telescope.algos.fzy').score(prompt, line)
        
        -- If no fuzzy match, don't show it
        if fzy_score == -1 then
          return -1
        end
        
        -- For matches, add proximity as a tie-breaker
        -- Higher fzy_score is better, lower distance is better
        local distance = calculate_path_distance(current_file, line)
        
        -- Scale fzy_score up and subtract distance penalty
        -- This keeps fuzzy matching primary but adds proximity sorting
        return fzy_score * 1000 - distance
      end,
    }),
  })
end

vim.keymap.set('n', '<leader>fg', builtin_tele.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>ff', find_files_by_proximity, { desc = 'Find files by proximity' })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Go to references' })
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function()
    vim.keymap.set('n', '<CR>', '<CR>:cclose<CR>', { buffer = true })
  end
})
vim.opt.number = true
vim.opt.relativenumber = true

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

-- Keybindings
vim.keymap.set('n', '<leader>tf', toggle_format_on_save, { desc = 'Toggle format on save' })
vim.keymap.set('n', '<leader>w', save_without_format, { desc = 'Save without formatting' })

-- Optional: Show current format-on-save status
vim.keymap.set('n', '<leader>fs', function()
  local status = vim.g.format_on_save and "enabled" or "disabled"
  print("Format on save is " .. status)
end, { desc = 'Show format on save status' })
