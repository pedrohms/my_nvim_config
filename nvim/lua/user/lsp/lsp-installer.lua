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
  "vuels",
  "svelte",
  "tailwindcss",
  "kotlin_language_server",
  "powershell_es",
  "lemminx"
}

lsp_installer.setup()

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
  --   opts = vim.tbl_deep_extend("force", jdtls_opts, opts)
  --   local jdtls_opts = require "user.lsp.settings.java_config"
  -- end

  lspconfig[server].setup(opts)
end
