-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

---@module 'lazy'
---@type LazySpec
return {
  'mfussenegger/nvim-dap',
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
    -- 'mfussenegger/nvim-dap-python',

    -- Add [d]ebug group
    {
      'folke/which-key.nvim',
      opts = function(_, opts)
        table.insert(opts['spec'], {
          { '<leader>d', group = '[d]ebug', mode = { 'n' } },
        })
      end,
    },
  },
  keys = {
    -- [d]ebug group keys
    { '<Leader>da', '<cmd>DapNew attach_all_code<CR>', desc = 'Attach, all code' },
    { '<Leader>dA', '<cmd>DapNew attach_my_code<CR>', desc = 'Attach, my code' },
    { '<leader>db', '<cmd>DapToggleBreakpoint<CR>', desc = 'Toggle breakpoint' },
    { '<leader>dc', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, desc = "Conditional b'point" },
    { '<leader>df', '<cmd>Telescope dap frames<CR>', desc = 'List frames' },
    { '<leader>dl', '<cmd>Telescope dap list_breakpoints<CR>', desc = 'List breakpoints' },
    { '<Leader>dL', function() require('dap').run_last() end, desc = 'Run last' },
    { '<Leader>dr', '<cmd>DapToggleRepl<CR>', desc = 'Toggle repl' },
    { '<Leader>dt', '<cmd>DapTerminate<CR>', desc = 'Terminate' },

    -- We don't use F-keys, we use arrow keys (see event listeners below),
    -- let's see how that goes...
    -- -- Basic debugging keymaps, feel free to change to your liking!
    -- { '<F5>', function() require('dap').continue() end, desc = 'Debug: Start/Continue' },
    -- { '<F1>', function() require('dap').step_into() end, desc = 'Debug: Step Into' },
    -- { '<F2>', function() require('dap').step_over() end, desc = 'Debug: Step Over' },
    -- { '<F3>', function() require('dap').step_out() end, desc = 'Debug: Step Out' },
    -- -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    -- { '<F7>', function() require('dapui').toggle() end, desc = 'Debug: See last session result.' },

    -- TODO: Some things we could do in the future
    --
    -- `set_breakpoint()` offers quite some features we could use
    -- set_breakpoint({condition}, {hit_condition}, {log_message})
    -- { '<leader>dB', function() require('dap').set_breakpoint() end, desc = 'Set breakpoint' },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
        'python',
      },
    }

    dap.adapters.python = function(cb, config)
      if config.request == 'attach' then
        local port = (config.connect or config).port
        local host = (config.connect or config).host or '127.0.0.1'
        local adapter = {
          type = 'server',
          port = assert(port, '`connect.port` is required for a python `attach` configuration'),
          host = host,
          --TODO: TODO
          -- enrich_config = function(config, on_config) end,
          options = {
            source_filetype = 'python',
          },
        }
        cb(adapter)
      end
    end

    -- Attach, only my code
    table.insert(dap.configurations.python, {
      justMyCode = true,
      type = 'python',
      request = 'attach',
      name = 'attach_my_code',
      connect = function()
        local host = vim.fn.input 'Host [127.0.0.1]: '
        host = host ~= '' and host or '127.0.0.1'
        local port = tonumber(vim.fn.input 'Port [5678]: ') or 5678
        return { host = host, port = port }
      end,
    })
    -- Attach, all code
    table.insert(dap.configurations.python, {
      justMyCode = false,
      type = 'python',
      request = 'attach',
      name = 'attach_all_code',
      connect = function()
        local host = vim.fn.input 'Host [127.0.0.1]: '
        host = host ~= '' and host or '127.0.0.1'
        local port = tonumber(vim.fn.input 'Port [5678]: ') or 5678
        return { host = host, port = port }
      end,
    })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    ---@diagnostic disable-next-line: missing-fields
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      ---@diagnostic disable-next-line: missing-fields
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Change breakpoint icons
    -- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    -- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    -- local breakpoint_icons = vim.g.have_nerd_font
    --     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
    --   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    -- for type, icon in pairs(breakpoint_icons) do
    --   local tp = 'Dap' .. type
    --   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
    --   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    -- end

    -- Debug start callback
    function dap_start_listener(session, payload)
      -- Open DAP UI
      dapui.open()

      -- Set keymaps when debugging starts
      vim.keymap.set('n', '<Right>', '<cmd>DapStepOver<CR>')
      vim.keymap.set('n', '<Down>', '<cmd>DapStepInto<CR>')
      vim.keymap.set('n', '<Up>', '<cmd>DapStepOut<CR>')
      vim.keymap.set('n', '<Left>', '<cmd>DapRestartFrame<CR>')
    end

    function dap_stop_listener(session, payload)
      -- Remove them when debugging ends
      vim.keymap.del('n', '<Left>')
      vim.keymap.del('n', '<Up>')
      vim.keymap.del('n', '<Down>')
      vim.keymap.del('n', '<Right>')

      -- Close DAP UI
      dapui.close()
    end

    -- Register DAP event listeners
    dap.listeners.after.event_initialized['dapui_config'] = dap_start_listener
    dap.listeners.before.event_terminated['dapui_config'] = dap_stop_listener
    dap.listeners.before.event_exited['dapui_config'] = dap_stop_listener

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }
  end,
}
