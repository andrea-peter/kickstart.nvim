return {
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
      enable = true,
      -- Line used to calculate context
      -- mode = 'cursor',
      mode = 'topline',
      separator = '-',
    },
  },
}
