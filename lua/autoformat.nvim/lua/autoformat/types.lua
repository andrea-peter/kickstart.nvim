---@class autoformat.EnableOnSaveOpts
---@field global? boolean Whether to enable format on save globally
---@field buffer? boolean Whether to enable format on save for current buffer

---@class autoformat.SetupOpts
---@field enable_on_save? autoformat.EnableOnSaveOpts
---@field disable_file_types? table<string> File types on which to disable autoformat
