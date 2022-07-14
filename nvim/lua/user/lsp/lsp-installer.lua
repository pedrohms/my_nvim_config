local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
  return
end

local servers = {
  "dartls",
  "emmet_ls",
  "eslint",
  "cssls",
  "html",
  "jdtls",
  "jsonls",
  "solc",
  "sumneko_lua",
  "tsserver",
  "pyright",
  "yamlls",
  "bashls",
  "clangd",
  "gopls",
  "volar",
  "svelte",
  "tailwindcss",
  "kotlin_language_server",
  "lemminx",
  "astro",
  "dockerls"
}

local settings = {
  ensure_installed = servers,
  ui = {
    icons = {},
    keymaps = {
      toggle_server_expand = "<CR>",
      install_server = "i",
      update_server = "u",
      check_server_version = "c",
      update_all_servers = "U",
      check_outdated_servers = "C",
      uninstall_server = "X",
    },
  },

  log_level = vim.log.levels.INFO,
}

lsp_installer.setup(settings)

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
  return
end

local opts = {}

for _, server in pairs(servers) do
  opts = {
    on_attach = require("user.lsp.handlers").on_attach,
    on_init = require("user.lsp.handlers").on_init,
    capabilities = require("user.lsp.handlers").capabilities,
  }

  if server == "sumneko_lua" then
    local sumneko_opts = require "user.lsp.settings.sumneko_lua"
    opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
  end

  if server == "pyright" then
    local pyright_opts = require "user.lsp.settings.pyright"
    opts = vim.tbl_deep_extend("force", pyright_opts, opts)
  end

  if server == "emmet_ls" then
    local emmet_ls_opts = require "user.lsp.settings.emmet_ls"
    opts = vim.tbl_deep_extend("force", emmet_ls_opts, opts)
  end

  if server == "gopls" then
    local gopls_opts = require "user.lsp.settings.gopls"
    opts = vim.tbl_deep_extend("force", gopls_opts, opts)
  end

  if server == "powershell_es" then
    local powershell_opts = {
      filetype = { "ps1" },
    }
    opts = vim.tbl_deep_extend("force", powershell_opts, opts)
  end
  -- if server == "jdtls" then
  --   local jdtls_opts = require "user.lsp.settings.java_config"
  --   require("user.log.log").println(vim.inspect(jdtls_opts))
  --   opts = vim.tbl_deep_extend("force", jdtls_opts, opts)
  -- end

  lspconfig[server].setup(opts)
end
