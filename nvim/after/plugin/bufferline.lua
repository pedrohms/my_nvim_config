local status_ok, bufferline = pcall(require, "bufferline")
if status_ok then
    vim.opt.termguicolors = true
    bufferline.setup {
        options = {
            offsets = {
                {
                    filetype = "NvimTree",
                    text = "",
                    padding = 1
                }
            },
            show_close_icon = false
        }
    }
end
