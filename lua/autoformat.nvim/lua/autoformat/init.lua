local M = {}

-- This is called if opts is given in spec
---@param opts? autoformat.SetupOpts
M.setup = function(opts)
  vim.tbl_deep_extend('error', vim.g.autoformat_opts, opts)
end

return M
