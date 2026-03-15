return {
  'folke/snacks.nvim',
  dependencies = {
    -- Add User interface group in which-key
    'folke/which-key.nvim',
    opts = function(_, opts)
      table.insert(opts['spec'], {
        { '<leader>u', group = '[U]ser interface', mode = { 'n' } },
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
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        Snacks.toggle.diagnostics():map '<leader>ud'
        Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map '<leader>ub'
        Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>us'
        Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'
      end,
    })
  end,
}
