local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
if status_ok then
  treesitter.setup {
    ensure_installed = "all",
    sync_install = false,

    highlight = {
      enable = true,
      additional_vim_regex_highlighting = true,
    },
    indent = {
      enable = false,
      disable = { "python", "css" },
    },
    autopairs = {
      enable = true,
    },
    autotag = {
      enable = true,
      disable = { "xml" },
    }
  }
end
