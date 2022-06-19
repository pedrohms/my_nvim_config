local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
if status_ok then
    treesitter.setup {
        ensure_installed = "all",
        sync_install = false,

        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
    }
end
