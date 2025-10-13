-- Telescope fuzzy finder configuration

return {
  "nvim-telescope/telescope.nvim",
  tag="0.1.8",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local builtin = require('telescope.builtin')

    require('telescope').setup({
      defaults={
        file_ignore_patterns = {
          "%.pyc$",
          "__pycache__/",
        }
      }
    })

    -- Helper function to calculate path distance
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

    -- Custom find files function with proximity sorting
    local function find_files_by_proximity()
      local current_file = vim.fn.expand('%:p')

      builtin.find_files({
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

    -- Telescope keymaps
    vim.keymap.set('n', '<leader>ff', find_files_by_proximity, { desc = 'Find files by proximity' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
  end,
}
