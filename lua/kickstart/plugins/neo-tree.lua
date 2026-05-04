-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

---@module 'lazy'
---@type LazySpec
return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  ---@module 'neo-tree'
  ---@type neotree.Config
  opts = {
    default_component_configs = {
      file_size = {
        enabled = false,
      },
      type = {
        enabled = false,
      },
      last_modified = {
        enabled = false,
      },
      created = {
        enabled = false,
      },
      symlink_target = {
        enabled = true,
      },
    },
    window = {
      mappings = {
        -- Open node with 'l' and close with 'h'
        ['l'] = 'open',
        ['h'] = 'close_node',
        -- Don't close neotree
        ['q'] = 'noop',
        -- We use space as leader
        ['<space>'] = 'noop',
      },
    },
    filesystem = {
      bind_to_cwd = true,
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
      window = {
        mappings = {
          ['\\'] = 'close_window',
          -- Inspired by https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/370#discussioncomment-4144005
          ['Y'] = function(state)
            -- NeoTree is based on [NuiTree](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree)
            -- The node is based on [NuiNode](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree#nuitreenode)
            local node = state.tree:get_node()
            local filepath = node:get_id()
            local filename = node.name
            local modify = vim.fn.fnamemodify

            local results = {
              filepath,
              modify(filepath, ':.'),
              modify(filepath, ':~'),
              filename,
              modify(filename, ':r'),
              modify(filename, ':e'),
            }

            vim.ui.select({
              '1. Absolute path: ' .. results[1],
              '2. Path relative to CWD: ' .. results[2],
              '3. Path relative to HOME: ' .. results[3],
              '4. Filename: ' .. results[4],
              '5. Filename without extension: ' .. results[5],
              '6. Extension of the filename: ' .. results[6],
            }, { prompt = 'Choose what to copy to clipboard:' }, function(choice)
              local i = tonumber(choice:sub(1, 1))
              local result = results[i]
              vim.fn.setreg('+', result)
              vim.notify('Copied: ' .. result)
            end)
          end,
        },
      },
    },
  },
}
