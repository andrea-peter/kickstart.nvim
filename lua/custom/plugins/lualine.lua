return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      -- One global status line
      globalstatus = true,
    },
    sections = {
      -- Relative path
      lualine_c = { { 'filename', path = 1 } },
    },
    -- tabline = {
    --   -- Buffer name and index
    --   lualine_a = { { 'buffers', mode = 2 } },
    -- },
  },
}
