-- Autocompletion configuration

return {
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
}
