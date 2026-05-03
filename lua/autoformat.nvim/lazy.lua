return {
  'autoformat.nvim',
  init = function(_)
    ---@type autoformat.SetupOpts
    local default_settings = {
      enable = {
        buffer = true,
        global = true,
      },
      disabled_file_types = {},
    }
    vim.g.autoformat_opts = default_settings

    vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPre' }, {
      -- pattern = '*',
      callback = function(_) vim.b.autoformat_disabled = vim.g.render_markdown_buf_enabled end,
    })

    -- Set up autoformat toggles
    Snacks = require 'snacks'
    local wk_desc_no_text = { enabled = '', disabled = '' }
    Snacks.toggle('autoformat_global', {
      name = 'Autoformat - global',
      get = function() return vim.g.autoformat_opts.enable.global end,
      set = function(enable) vim.g.autoformat_opts.enable.global = enable end,
      wk_desc = wk_desc_no_text,
    }):map '<leader>ufg'
    Snacks.toggle('autoformat_buffer', {
      name = 'Autoformat - buffer',
      get = function() return vim.b.disable_autoformat end,
      set = function(enable) vim.b.disable_autoformat = enable end,
      wk_desc = wk_desc_no_text,
    }):map '<leader>ufb'
  end,

  dependencies = {
    {
      'stevearc/conform.nvim',
      lazy = false,
      opts = function(_, opts)
        opts.format_on_save = function(bufnr)
          -- Don't format if disabled globally or in buffer
          if not vim.g.autoformat_opts.enable.global then return nil end
          if vim.b[bufnr].disable_autoformat then return nil end
          -- Disable autoformat for specific file types
          if vim.g.autoformat_opts.disabled_file_types[vim.bo[bufnr].filetype] ~= nil then return nil end
          -- Format
          return {
            timeout_ms = 500,
          }
        end
      end,
    },
    {
      'folke/snacks.nvim',
      lazy = false,
      opts = function(_, opts)
        table.insert(opts, {
          toggle = { enabled = true },
        })
      end,
    },
    {
      'folke/which-key.nvim',
      lazy = false,
      opts = function(_, opts)
        if opts.spec == nil then opts.spec = {} end
        table.insert(opts['spec'], { '<leader>uf', group = 'Auto[f]ormat', mode = { 'n' } })
      end,
    },
  },
}
