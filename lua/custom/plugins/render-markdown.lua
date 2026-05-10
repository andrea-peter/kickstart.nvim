DEFAULT_ENABLED = false

return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = {
    {
      'folke/snacks.nvim',
      opts = { toggle = { enabled = true } },
    },
    'nvim-treesitter/nvim-treesitter',

    -- ICONS - Choose one
    -- 'nvim-mini/mini.nvim',
    -- 'nvim-mini/mini.icons',
    'nvim-tree/nvim-web-devicons',
    -- END ICONS
  },
  init = function(_)
    -- Set default markdown rendering on new buffers
    vim.g.render_markdown_buf_enabled = DEFAULT_ENABLED
    vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPre' }, {
      pattern = '*.md',
      callback = function(_) vim.b.render_markdown_enabled = vim.g.render_markdown_buf_enabled end,
    })

    -- Toggle markdown rendering on buffer
    Snacks = require 'snacks'
    Snacks.toggle('render_markdown', {
      name = 'Render markdown',
      get = function() return vim.b.render_markdown_enabled end,
      set = function(enabled)
        vim.b.render_markdown_enabled = enabled
        if enabled then
          vim.cmd 'RenderMarkdown buf_enable'
        else
          vim.cmd 'RenderMarkdown buf_disable'
        end
      end,
      wk_desc = { enabled = '', disabled = '' },
    }):map '<leader>um'
  end,

  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    enabled = DEFAULT_ENABLED,
  },
}
