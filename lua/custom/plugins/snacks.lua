return {
  'folke/snacks.nvim',
  dependencies = {
    -- Add User interface group in which-key
    'folke/which-key.nvim',
    opts = function(_, opts)
      table.insert(opts['spec'], {
        { '<leader>u', group = '[U]ser interface', mode = { 'n' } },
        { '<leader>uf', group = 'Auto[f]ormat', mode = { 'n' } },
      })
    end,
  },
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = false },
    dashboard = { enabled = false },
    explorer = { enabled = false },
    indent = { enabled = false },
    input = { enabled = false },
    picker = { enabled = false },
    notifier = { enabled = false },
    quickfile = { enabled = false },
    scope = { enabled = false },
    scroll = { enabled = false },
    statuscolumn = { enabled = false },
    toggle = { enable = true },
    words = { enabled = false },
  },
  keys = {
    {
      '<leader>bd',
      function() Snacks.bufdelete() end,
      desc = 'Delete Buffer',
    },
  },
  init = function()
    -- Getters and setters for autoformat, global and buffer
    local set_global_autoformat = function(enable) vim.g.disable_autoformat = not enable end
    local get_global_autoformat = function() return not vim.g.disable_autoformat end
    local set_buffer_autoformat = function(enable) vim.b.disable_autoformat = not enable end
    local get_buffer_autoformat = function() return not vim.b.disable_autoformat end
    local wk_desc_no_text = { enabled = '', disabled = '' }

    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        Snacks.toggle.diagnostics():map '<leader>ud'
        Snacks.toggle(
          'autoformat_global',
          { name = 'Autoformat - global', get = get_global_autoformat, set = set_global_autoformat, wk_desc = wk_desc_no_text }
        )
          :map '<leader>ufg'
        Snacks.toggle(
          'autoformat_buffer',
          { name = 'Autoformat - buffer', get = get_buffer_autoformat, set = set_buffer_autoformat, wk_desc = wk_desc_no_text }
        )
          :map '<leader>ufb'
        Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map '<leader>ub'
        Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>us'
        Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'
      end,
    })
  end,
}
