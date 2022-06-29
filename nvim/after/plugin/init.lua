vim.cmd [[ colorscheme aurora ]]

require "user.lsp"
local status_ok, comment = pcall(require, "Comment")
if status_ok then
    comment.setup()
end
